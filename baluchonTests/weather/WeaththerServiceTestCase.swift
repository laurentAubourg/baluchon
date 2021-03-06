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
    
    //MARK: I. getWeather test invalidData
    
    func  testDataIsIncorrect_WhenWeatherShouldPost_ThenReceiveUndecodableData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlWeather: (FakeResponseData.incorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: WeatherService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getWeather{ result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .undecodableData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    //MARK: II. getWeather  test invalidResponse
    
    func  testInvalidResponse_WhenWeatherShouldPost_ThenReceiveInvalidResponse(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlWeather: (FakeResponseData.weatherCorrectData, FakeResponseData.responseKO, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: WeatherService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getWeather { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .invalidResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    //MARK: III. weather test .nodata
    
    func  testNoData_WhenDataIsNull_ThenReceiveNoData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlWeather: (nil, FakeResponseData.responseOK, FakeResponseData.error)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: WeatherService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getWeather{ result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    //MARK: IV weather test data and response are OK
    
    func   testData_WhenDataIsCorrect_ThenReceiveData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlWeather: (FakeResponseData.weatherCorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: WeatherService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getWeather{ result in
            switch result {
                
            case .success(_):
              
                XCTAssertTrue(true)
            case .failure( let error):
                XCTFail("Test failed: \(error)")
                return
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: V weather test data and response are OK Anad cancel Old request
    
    func  testData_WhenDataIsCorrect_ThenReceiveDataAndCancelOldRequest(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlWeather: (FakeResponseData.weatherCorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: WeatherService = .init(session: fakeSession)
        sut.lastUrl = FakeResponseData.urlWeather
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.getWeather{ result in
            switch result {
                
            case .success(_):
              
                XCTAssertTrue(true)
            case .failure( let error):
                XCTFail("Test failed: \(error)")
                return
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
                       
