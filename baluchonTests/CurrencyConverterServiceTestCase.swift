//
//  baluchonTests.swift
//  baluchonTests
//
//  Created by laurent aubourg on 25/08/2021.
//

import XCTest
@testable import baluchon

class CurrencyConverterServiceTestCase: XCTestCase {

    func testGetRateShouldPostFailedCallbackError(){
        let sut = CurrencyConverterService(rateSession: UrlSessionFake(data: nil, response: nil, error: (FakeResponseData.RateError()) ))
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        sut.getRate{result in
            guard case .failure (let error) =  result else {return}
            XCTAssertTrue ( error == .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

}

