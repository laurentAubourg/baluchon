//
//  translatorServiceTest.swift
//  baluchonTests
//
//  Created by laurent aubourg on 15/09/2021.
//

import XCTest
@testable import baluchon

//MARK: translate test invalidData

class translatorServiceTestCase: XCTestCase {
    // MARK: - Properties
    
    private let sessionConfiguration: URLSessionConfiguration = {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolFake.self]
        return sessionConfiguration
    }()
    
    //MARK: I. translate test invalidData
    
    func  testDataIsIncorrect_WhenTranslateShouldPost_ThenReceiveUndecodableData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlTranslate: (FakeResponseData.incorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.translate(textToTranslate:"hello") { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .undecodableData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    //MARK: II.  translate test invalidResponse
    
    func  testInvalidResponse_WhenTranslateShouldPost_ThenReceiveInvalidResponse(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlTranslate: (FakeResponseData.translatorCorrectData, FakeResponseData.responseKO, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.translate(textToTranslate:"hello") { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .invalidResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: III. translate test .nodata
    
    func  testNoData_WhenDataIsNull_ThenReceiveNoData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlTranslate: (nil, FakeResponseData.responseOK, FakeResponseData.error)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.translate(textToTranslate:"hello") { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: IV translate test data and response are OK
    
    func  testData_WhenDataIsCorrect_ThenReceiveData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlTranslate: (FakeResponseData.translatorCorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.translate(textToTranslate:"hello") { result in
            switch result {
            case .success(let data):
                let text = data.translations[0].text
                XCTAssertTrue(text == "bonjour")
            case .failure( let error):
                XCTFail("Test failed: \(error)")
                return
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    //MARK: V translate test data and response are OK Anad cancel Old request
    
    func  testData_WhenDataIsCorrect_ThenReceiveDataAndCancelOldRequest(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlTranslate: (FakeResponseData.translatorCorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        sut.lastUrl = FakeResponseData.urlLanguages
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.translate(textToTranslate:"hello") { result in
            switch result {
            case .success(let data):
                let text = data.translations[0].text
                XCTAssertTrue(text == "bonjour")
            case .failure( let error):
                XCTFail("Test failed: \(error)")
                return
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    //MARK: I. targetLanguages test invalidData
    
    func  testDataIsIncorrect_listLanguagesShouldPost_ThenReceiveUndecodableData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlLanguages: (FakeResponseData.incorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.targetLanguages { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .undecodableData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: II.  targetLanguages test invalidResponse
    
    func  testInvalidResponse_WhenLanguageShouldPost_ThenReceiveInvalidResponse(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlLanguages: (FakeResponseData.languagesCorrectData, FakeResponseData.responseKO, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.targetLanguages { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .invalidResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    //MARK: III. targetLanguages test .nodata
    
    func  testNoData_WhenLanguageDataIsNull_ThenReceiveNoData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlLanguages: (nil, FakeResponseData.responseOK, FakeResponseData.error)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.targetLanguages { result in
            
            guard case .failure(let error) = result else {
                XCTFail("Test failed: \(#function)")
                return
            }
            XCTAssertTrue(error == .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //MARK: IV translate test data and response are OK
    
    func  testData_WhenLanguageDataIsCorrect_ThenReceiveData(){
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlLanguages: (FakeResponseData.languagesCorrectData, FakeResponseData.responseOK, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...change threat")
        sut.targetLanguages { result in
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

