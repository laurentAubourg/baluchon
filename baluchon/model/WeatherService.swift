//
//  WeatherService.swift
//  baluchon
//
//  Created by laurent aubourg on 03/09/2021.
//

import Foundation
class WeatherService:UrlSessionCancelable,UrlBuildable{

    //MARK : properties
    
    var lastUrl:URL = URL(string:"http://")!
   
    var baseUrl = "https://api.openweathermap.org/data/2.5/group"
    internal var  session : URLSession

    //MARK : methods
    

    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    //MARK : - Sends a request to openWzeather then waits for its response
    
    func getWeather(callback: @escaping( Result<WeatherResponse,NetworkError>)->Void) {
        let queryItem:[[String:String]] = [["name":"APPID","value":"\(idKey)"],
                                           ["name":"id","value":"5128638,2992090"],
                                           ["name":"units","value":"metric"],
                                           ["name":"metric","value":"Celsius"]]
        guard let url = buildUrl(baseUrl:"https://api.openweathermap.org/data/2.5/group",
        Items:queryItem)  else{
            callback(.failure(.badUrl))
            return
            
        }
       print (url)
        guard lastUrl != URL(string:"http://")! else{
            session.dataTask(with: url, callback: callback)
            lastUrl = url
            return
        }
        cancel(lastUrl)
        lastUrl = url
        session.dataTask(with: url, callback: callback)
    }
  
}
//MARK: : - JSON structures decod format

// MARK: - Weather Structure
struct WeatherResponse: Decodable {
    let cnt: Int
    let list: [List]
}

// MARK: - List
struct List: Decodable {
    let id: Int
    let weather: [Weather]
    let main: Main
    let name: String
}

// MARK: - Main
struct Main: Decodable {
    let temp: Double
}

// MARK: - Weather
struct Weather: Decodable {
    let weatherDescription, icon: String?
    
    enum CodingKeys: String, CodingKey {
           case weatherDescription = "description"
           case icon
    }
}

