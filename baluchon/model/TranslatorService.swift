//
//  CurrencyConverterService.swift
//  baluchon
//
//  Created by laurent aubourg on 27/08/2021.
//
//
import Foundation

class TranslatorService{
    
   
    
    //MARK : properties
    
    
    private var task: URLSessionDataTask?
    private let  rateSession : URLSession

    //MARK : methods
    

    init(rateSession:URLSession = URLSession(configuration: .default)){
        self.rateSession = rateSession
    }
    func getRate(callback: @escaping( Result<FixerResponse,NetworkError>)->Void) {
        guard let url = URL(string: "https://api-free.deepl.com/v2/translate?auth_key=58bd7ff0-4c65-2110-6bbb-3c75f0ca37fd:fx&text=\"bonjour\"&&target_lang=EN")else {
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



