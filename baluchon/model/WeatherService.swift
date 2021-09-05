//
//  WeatherService.swift
//  baluchon
//
//  Created by laurent aubourg on 03/09/2021.
//

import Foundation
class WeatherService{
    //MARK : properties
    
    
    private var task: URLSessionDataTask?
    private let  weatherSession : URLSession

    //MARK : methods
    init(weatherSession:URLSession = URLSession(configuration: .default)){
        self.weatherSession = weatherSession
    }
    func getWeather(callback: @escaping( Result<WeatherResponse,NetworkError>)->Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/group?id=5128638,2992090&units=imperial&APPID=ed85328d8805688318a5b56fffe020d0")else{
            callback(.failure(.badUrl))
            return
        }
        task?.cancel()
        task = weatherSession.dataTask(with: url) { (data, response, error) in
            
                guard let data = data, error == nil else{
                    callback(.failure(.noData))
                    return
                }
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                callback(.failure(.invalidResponse))
                return
            }
            
                guard let responseJSON = try? JSONDecoder().decode(WeatherResponse.self, from: data) else{
                    callback(.failure(.undecodableData))
                    return
                }
          
            callback(.success(responseJSON))
            }
        task?.resume()
    }
  
}
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
