//
//  MockAPIClient.swift
//  WeatherReportTests
//
//  Created by Amrata Sharma on 18/06/23.
//

import XCTest
@testable import WeatherReport

class NetworkRequestTests: XCTestCase {
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
           // Set url session for mock networking
           let configuration = URLSessionConfiguration.ephemeral
           configuration.protocolClasses = [MockURLProtocol.self]
           urlSession = URLSession(configuration: configuration)
    }
    
    func testGetWeatherReport() {
        let apiRequest = NetworkRequest(urlSession: urlSession)
        let request = WeatherReportRequest(latitude: 18.52043, longitude: 73.856743)
        let mockJsonData = testGeoCoordinatesData
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.query?.contains("lat=18.52043"), true)
            return (HTTPURLResponse(), mockJsonData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        apiRequest.getWeatherReport(request: request) { (weatherReport: DataModel) in
            print("weatherReport", weatherReport)
            XCTAssertEqual("\(weatherReport.coord.lon)", "73.8554")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
}
