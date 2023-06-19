//
//  WeatherReportViewModel.swift
//  WeatherReport
//
//  Created by Amrata Sharma on 13/06/23.
//

import Foundation

struct WeatherReportRequest : APIRequest {
    typealias Response = DataModel
    var latitude : Double
    var longitude : Double
    var resourcePath: String {
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=f38d8d375723f8d1e266338e3552b630"
    }
}

struct PlaceCoordinatesRequest : APIRequest {
    typealias Response = PlaceCoordinates
    var cityName : String
    var resourcePath: String {
            return "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=5&appid=f38d8d375723f8d1e266338e3552b630"
    }
}

struct CachedObject: Codable {
    var image: Data
    var cityName: String
    var temperature: String

    init(image: Data, cityName: String, temperature: String ) {
        self.image = image
        self.cityName = cityName
        self.temperature = temperature
    }
}

protocol WeatherReportViewModelProtocol {
    func getWeatherReport(latitude: Double, longitude: Double, success : @escaping (_ result: DataModel)->())
    func getWeatherStatuaIcon(iconName: String, success : @escaping (_ result: Data?)->())
    func getPlaceCoordinates(placeName: String, success : @escaping (_ result: PlaceCoordinates?)->())
}

public class WeatherReportViewModel: WeatherReportViewModelProtocol {
    let apiService: NetworkRequestProtocol
    
    init( apiService: NetworkRequestProtocol = NetworkRequest()) {
        self.apiService = apiService
    }
    
    func getWeatherReport(latitude: Double, longitude: Double, success : @escaping (_ result: DataModel)->()) {
        let model = WeatherReportRequest(latitude: latitude, longitude: longitude)
        apiService.getWeatherReport(request: model) { data in
            if let weatherReport: DataModel = data {
                success(weatherReport)
            }
        }
    }
    
    func getWeatherStatuaIcon(iconName: String, success : @escaping (_ result: Data?)->()) {
        apiService.downloadImage("https://openweathermap.org/img/w/\(iconName).png") { imageData, str in
            success(imageData)
        }
    }
    
    func getPlaceCoordinates(placeName: String, success : @escaping (_ result: PlaceCoordinates?)->()) {
        let model = PlaceCoordinatesRequest(cityName: placeName)
        apiService.getGeoCoordinates(request: model) { result in
            let coordinates =  result.first { coord in
                coord.country == "US"
            }
            success(coordinates ?? nil)
        }
    }
}


