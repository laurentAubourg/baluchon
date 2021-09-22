//
//  translatorServiceTest.swift
//  baluchonTests
//
//  Created by laurent aubourg on 15/09/2021.
//

import XCTest
@testable import baluchon

class WeaththerServiceTestCase: XCTestCase {
    // MARK: - PropertiesK

    private let sessionConfiguration: URLSessionConfiguration = {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolFake.self]
        return sessionConfiguration
    }()

    func testGetWeatherShouldPostFailedCallbackError(){
        
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlWeather: (FakeResponseData.weatherCorrectData, FakeResponseData.weatherResponseKO, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: WeatherService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getWeather() { result in
        print(result)
            guard case .failure(let error) = result else {
               XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .invalidResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

}

