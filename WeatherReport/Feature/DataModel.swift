//
//  DataModel.swift
//  WeatherReport
//
//  Created by Amrata Sharma on 13/06/23.
//

import Foundation

struct DataModel: APIResponse {
    let coord : Coordinates
    let main: Details
    let name : String
    let weather : [Weather]
    
    struct Coordinates: Decodable {
        let lon : Double
        let lat : Double
    }
    
    struct Details: Decodable {
        let temp : Double
        let temp_min : Double
        let temp_max : Double
        let humidity : Int
    }
    
    struct Weather: Decodable {
        let description : String
        let icon : String
    }
}

struct PlaceCoordinates : Equatable, APIResponse {
    let lon : Double
    let lat : Double
    let country: String
}
