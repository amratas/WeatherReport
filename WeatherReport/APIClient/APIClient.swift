//
//  APIClient.swift
//  WeatherReport
//
//  Created by Amrata Sharma on 13/06/23.
//

import Foundation

public protocol API: Encodable {
    var resourcePath: String { get }
}

public protocol APIResponse: Decodable {
}

public protocol APIRequest: API {
    associatedtype Response: APIResponse
}

protocol NetworkRequestProtocol {
    func getWeatherReport<T: Decodable>(request : any APIRequest ,_ weatherDetails : @escaping (T)->()?)
    func downloadImage(_ urlString: String, completion: ((_ _imageData: Data?, _ urlString: String?) -> ())?)
    func  getGeoCoordinates(request : any APIRequest, _ success : @escaping ([PlaceCoordinates])->()?)
}

class NetworkRequest: NetworkRequestProtocol {
    
    private let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    //a generic method to make network request...
    func getWeatherReport<T: Decodable>(request : any APIRequest ,_ weatherDetails : @escaping (T)->()?) {
        
        guard let url = URL(string: request.resourcePath) else {
            print("url")
            return
        }
        
        let task = session.dataTask(with: url) {
            data, response, error in
            
            if let jsonData = data {
                guard let data = self.decode(jsonData: jsonData, using: T.self) else {
                    print("error")
                    return
                }
                weatherDetails(data.self)
            }
        }
        task.resume()
    }
    
    private func decode<T: Decodable>(jsonData: Data, using modelType: T.Type) -> T? {
        do {
            //here dataResponse received from a network request
            let decoder = JSONDecoder()
            let data = try decoder.decode(modelType.self, from: jsonData) //Decode JSON Response Data
            return data
        } catch let parsingError {
            print("Error", parsingError)
        }
        return nil
    }
    
    //Network call to download Image...
    func downloadImage(_ urlString: String, completion: ((_ _imageData: Data?, _ urlString: String?) -> ())?) {
          guard let url = URL(string: urlString) else {
             completion?(nil, urlString)
             return
         }
        session.dataTask(with: url) { (data, response,error) in
            if let error = error {
               print("error in downloading image: \(error)")
               completion?(nil, urlString)
               return
            }
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
               completion?(nil, urlString)
               return
            }
            if let data = data {
               completion?(data, urlString)
               return
            }
            completion?(nil, urlString)
         }.resume()
      }
    
    
    //created seperate network call to get place coordinates as this call return result in []array json...
    //can also make it generic so as to handle more response like this using this method..
    func  getGeoCoordinates(request : any APIRequest, _ success : @escaping ([PlaceCoordinates])->()?) {
        guard let urlString = request.resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {
            return
        }
        let task = session.dataTask(with: url){
            data, response, error in
            
            if let jsonData = data {
                do {
                    let data = try JSONDecoder().decode([PlaceCoordinates].self, from: jsonData)
                    success(data)
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        task.resume()
    }
}

