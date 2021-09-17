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
class CurrencyConverterService:UrlSessionCancelable,
                               UrlBuildable{
    
    //MARK : properties
    var baseUrl = "http://data.fixer.io/api/latest"

    
    var lastUrl:URL = URL(string:"http://")!
     
    internal var  session : URLSession

    //MARK : methods
    

    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
   // MARK: - Request exchange rate from API
     
    func getRate(callback: @escaping( Result<FixerResponse,NetworkError>)->Void) {
        var queryItem = [["name":"access_key","value":"\(idKey)"],            ["name":"symbols","value":"USD,EUR"]]
        guard let url = buildUrl(baseUrl:baseUrl,Items:queryItem)  else {
            callback(.failure(.badUrl))
            return
            
        }
          
      //  cancel(lastUrl)
        lastUrl = url
        session.dataTask(with: url, callback: callback)
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

