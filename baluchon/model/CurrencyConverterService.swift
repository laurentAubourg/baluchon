//
//  CurrencyConverterService.swift
//  baluchon
//
//  Created by laurent aubourg on 27/08/2021.
//
//
import Foundation
enum NetworkError:Error{
    case badUrl,noData, invalidResponse,undecodableData
}
class CurrencyConverterService{
    
 
    
    //MARK : properties
    
    
    private var task: URLSessionDataTask?
    private let  rateSession : URLSession

    //MARK : methods
    

    init(rateSession:URLSession = URLSession(configuration: .default)){
        self.rateSession = rateSession
    }
   // MARK: - Request exchange rate from API
    func getRate(callback: @escaping( Result<FixerResponse,NetworkError>)->Void) {
        guard let url = URL(string: "http://data.fixer.io/api/latest?access_key=3c89a5b6c8681ae01f005a879bfb8509&symbols=USD,EUR")else {
            callback(.failure(.badUrl))
            return
            
        }
        task?.cancel()
        task = rateSession.dataTask(with: url) { (data, response, error) in
            
                guard let data = data, error == nil else{
                    callback(.failure(.noData))
                    return
                }
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else{
                callback(.failure(.invalidResponse))
                return
            }
            
                guard let responseJSON = try? JSONDecoder().decode(FixerResponse.self, from: data) else{
                    callback(.failure(.undecodableData))
                    return
                }
          
            callback(.success(responseJSON))
            }
        
        
        task?.resume()
    }
}

// MARK: decodable struct
struct Rates: Decodable {
    let usd: Double
    let eur: Int
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case eur = "EUR"
    }
}
struct FixerResponse: Decodable{
    let success: Bool
    let timestamp: Int
    let base: String
    let rates: Rates
}

