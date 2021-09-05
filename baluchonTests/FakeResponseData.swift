//
//  FakeRespo,seData.swift
//  baluchonTests
//
//  Created by laurent aubourg on 30/08/2021.
//

import Foundation
class FakeResponseData{
    let responseOk = HTTPURLResponse(url: URL(string:"http://pipo")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    let responseKo = HTTPURLResponse(url: URL(string:"http://pipo")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    class RateError:Error{}
    let error =  RateError()
    var RateCorrectData:Data{
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Rate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    let rateIncorrectData = "error".data(using: .utf8)!
}
