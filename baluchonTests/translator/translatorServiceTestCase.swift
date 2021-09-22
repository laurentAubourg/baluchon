//
//  translatorServiceTest.swift
//  baluchonTests
//
//  Created by laurent aubourg on 15/09/2021.
//

import XCTest
@testable import baluchon

class translatorServiceTestCase: XCTestCase {
    // MARK: - PropertiesK

    private let sessionConfiguration: URLSessionConfiguration = {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolFake.self]
        return sessionConfiguration
    }()

    func testTranslateShouldPostFailedCallbackError(){
        
        
        URLProtocolFake.fakeURLs = [FakeResponseData.urlTranslate: (FakeResponseData.translatorCorrectData, FakeResponseData.translateResponseKO, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut: TranslatorService = .init(session: fakeSession)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.translate(textToTranslate:"bonjour") { result in
        
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

