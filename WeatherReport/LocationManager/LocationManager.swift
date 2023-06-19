//
//  LocationManager.swift
//  WeatherReport
//
//  Created by Amrata Sharma on 13/06/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()

    private func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func getCurrentLocationCoordinates(_ cordinates : (CLLocationCoordinate2D)->()?) {
        let currentStatus = locationManager.authorizationStatus
        if currentStatus == .notDetermined  {
            requestLocationAuthorization()
        }else {
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else {
                //Returning static coordinates in failure, as i don't have profile to run this code on actual device...
                cordinates(CLLocation(latitude: 18.516726, longitude: 73.856255).coordinate)
                return
            }
            //with actual device we will get live coordinates...
            cordinates(locValue)
        }
    }
}



