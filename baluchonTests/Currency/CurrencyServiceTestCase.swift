//
//  baluchonTests.swift
//  baluchonTests
//
//  Created by laurent aubourg on 25/08/2021.
//

import XCTest
@testable import baluchon

class CurrencyServiceTestCase: XCTestCase {
    // MARK: - Properties

    private let sessionConfiguration: URLSessionConfiguration = {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolFake.self]
        return sessionConfiguration
    }()
    
    //MARK: I getRate  test invalidData
    
    func  testDataIsIncorrect_WhenTranslateShouldPost_ThenReceiveUndecodableData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlCurrency: (FakeResponseData.incorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: CurrencyService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.getRate() { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .undecodableData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: II. getRate  test invalidResponse
    
    func  testInvalidResponse_WhenTranslateShouldPost_ThenReceiveInvalidResponse(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlCurrency: (FakeResponseData.currencyCorrectData, FakeResponseData.responseKO, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: CurrencyService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getRate { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .invalidResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: III. getRate test .nodata
    
    func  testNoData_WhenDataIsNull_ThenReceiveNoData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlCurrency: (nil, FakeResponseData.responseOK, FakeResponseData.error)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: CurrencyService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getRate { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: IV getRate test data and response are OK
    
    func  testData_WhenDataIsCorrect_ThenReceiveData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlCurrency: (FakeResponseData.currencyCorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: CurrencyService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getRate { result in
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
    //MARK: V. getRate test data and response are OK Anad cancel Old request
    
    func  testData_WhenDataIsCorrect_ThenReceiveDataAndCancelOldRequest(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlCurrency: (FakeResponseData.currencyCorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: CurrencyService = .init(session: fakeSession)
        sut.lastUrl = FakeResponseData.urlCurrency
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.getRate{ result in
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

