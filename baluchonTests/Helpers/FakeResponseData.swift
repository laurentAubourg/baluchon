//
//  FakeResponseData.swift
//  TestsByExampleTests
//
//  Created by Sebastien Bastide on 26/07/2021.
//

import Foundation

class FakeResponseData {
    
    static let url: URL = URL(string: "http://pipo.org")!
    
    static let responseOK = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
     


    class NetworkError: Error {}
    static let error = NetworkError()

    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Rate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }

    static let incorrectData = "erreur".data(using: .utf8)!
}
