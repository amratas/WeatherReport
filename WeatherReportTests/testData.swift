//
//  testData.swift
//  WeatherReportTests
//
//  Created by Amrata Sharma on 18/06/23.
//

import Foundation

let testGeoCoordinatesData = """
{"coord":{"lon":73.8554,"lat":18.5196},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"base":"stations","main":{"temp":302.07,"feels_like":303.76,"temp_min":302.07,"temp_max":302.07,"pressure":1007,"humidity":58,"sea_level":1007,"grnd_level":947},"visibility":10000,"wind":{"speed":6.2,"deg":276,"gust":7.27},"clouds":{"all":100},"dt":1687093033,"sys":{"country":"IN","sunrise":1687048104,"sunset":1687095767},"timezone":19800,"id":1259229,"name":"Pune","cod":200}
""".data(using: .utf8)!
