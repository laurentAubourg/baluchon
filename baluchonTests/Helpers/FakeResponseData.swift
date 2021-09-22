//
//  FakeResponseData.swift
//  TestsByExampleTests
//
//  Created by Sebastien Bastide on 26/07/2021.
//

import Foundation

class FakeResponseData {
    
    static let urlWeather: URL = URL(string: "https://api.openweathermap.org/data/2.5/group?APPID=ed85328d8805688318a5b56fffe020d0&id=5128638,2992090&units=metric&metric=Celsius")!
    static let urlTranslate: URL = URL(string: "https://api-free.deepl.com/v2/translate?auth_key=58bd7ff0-4c65-2110-6bbb-3c75f0ca37fd:fx&text=bonjour&target_lang=FR")!
  
    static let urlCurrency: URL = URL(string: "http://data.fixer.io/api/latest?access_key=3c89a5b6c8681ae01f005a879bfb8509&symbols=USD,EUR")!
    
    static let weatherResponseOK = HTTPURLResponse(url: urlWeather, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let weatherResponseKO = HTTPURLResponse(url: urlWeather, statusCode: 500, httpVersion: nil, headerFields: nil)!
 
    static let currencyResponseOK = HTTPURLResponse(url: urlCurrency, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let currencyResponseKO = HTTPURLResponse(url:urlCurrency, statusCode: 500, httpVersion: nil, headerFields: nil)!
     
    static let translateResponseOK = HTTPURLResponse(url: urlTranslate , statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let translateResponseKO = HTTPURLResponse(url:urlTranslate , statusCode: 500, httpVersion: nil, headerFields: nil)!

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
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let incorrectData = "erreur".data(using: .utf8)!
}
