//
//  ViewController.swift
//  WeatherReport
//
//  Created by Amrata Sharma on 13/06/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var weatherIndication: UIImageView!
    @IBOutlet weak var labelDisplayTempreture: UILabel!
    let viewModel = WeatherReportViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getWeatherReportForCurrentLocation()
    }
        
    private func getWeatherReportForCurrentLocation() {
        //check for saved searched data, if exist....
        if let decodedData = UserDefaults.standard.object(forKey:"itemKey") as? Data {
           if let userDetails = try? JSONDecoder().decode(CachedObject.self, from: decodedData) {
               self.labelCityName.text = userDetails.cityName
               self.labelDisplayTempreture.text = userDetails.temperature
               self.weatherIndication.image = UIImage.init(data: userDetails.image)
          }
        }else {//show current location data on applauch
               //Show weather report on basis of current location
            LocationManager.shared.getCurrentLocationCoordinates({ coordinates in
                getWeatherReport(latitude: coordinates.latitude, longitude: coordinates.longitude)
            })
        }
    }
    
    func getWeatherReport(latitude: Double, longitude: Double) {
        let dispatchGroup = DispatchGroup()
        var weatherData: DataModel?

        dispatchGroup.enter()
        viewModel.getWeatherReport(latitude: latitude, longitude: longitude) { result in
            weatherData = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            guard let weatherReprot = weatherData else {return}
            self.labelCityName.text = weatherReprot.name
            self.labelDisplayTempreture.text = "\(weatherReprot.main.temp)"
            
            //make second network call if fetch image if icon id is present...
            if let imageId = weatherReprot.weather.first?.icon {
                self.viewModel.getWeatherStatuaIcon(iconName: imageId) {[weak self] result in
                    if let imageData = result {
                        DispatchQueue.main.async {
                            guard let img = UIImage(data: imageData) else { return  }
                            self?.weatherIndication.image = img
                            
                            //Save last searched object to show on app relaunch...
                            let objectToCache = CachedObject(image: imageData, cityName: weatherReprot.name, temperature: "\(weatherReprot.main.temp)")
                            if let encodedUserDetails = try? JSONEncoder().encode(objectToCache) {
                               UserDefaults.standard.set(encodedUserDetails, forKey: "itemKey")
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchViewController = self.storyboard?.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else {
                    print("Something wrong in storyboard")
                    return
                }
        searchViewController.homeControllerDelegate = self
        self.navigationController?.present(searchViewController, animated: true)
    }
}

extension ViewController : HomeViewControllerProtocol {
    func didGetStateName(_ name: String) {
        viewModel.getPlaceCoordinates(placeName: name) { [weak self] result in
            if let coordinates = result {
                self?.getWeatherReport(latitude: coordinates.lat, longitude: coordinates.lon)
            }
        }
    }
}






