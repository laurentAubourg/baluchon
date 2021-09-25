//
//  FakeResponseData.swift
//  TestsByExampleTests
//
//  Created by Sebastien Bastide on 26/07/2021.
//

import Foundation

class FakeResponseData {
    
    static let urlWeather: URL = URL(string: "https://api.openweathermap.org/data/2.5/group?APPID=\(ApiKey.openWeather)&id=512863,2992090&units=metric&metric=Celsius")!
    static let urlTranslate: URL = URL(string: "https://api-free.deepl.com/v2/translate?auth_key=\(ApiKey.deeple)&text=hello&target_lang=FR")!
    static let urlLanguages: URL = URL(string: "https://api-free.deepl.com/v2/languages?auth_key=\(ApiKey.deeple)&type=target")!

    static let urlCurrency: URL = URL(string: "http://data.fixer.io/api/latest?access_key=\(ApiKey.fixer)&symbols=USD,EUR")!
    
   
     
    static let responseOK = HTTPURLResponse(url: urlTranslate , statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url:urlTranslate , statusCode: 500, httpVersion: nil, headerFields: nil)!

    class NetworkError: Error {}
    static let error = NetworkError()

    static var currencyCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Rate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static var translatorCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Translator", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static var languagesCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "languagesTarget", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let incorrectData = "erreur".data(using: .utf8)!
}
