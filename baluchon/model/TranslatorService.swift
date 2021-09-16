//
//  CurrencyConverterService.swift
//  baluchon
//
//  Created by laurent aubourg on 27/08/2021.
//
//
import Foundation

class TranslatorService:UrlSessionCancelable,UrlBuildable{
    
    
    //MARK : properties
    
    var lastUrl:URL = URL(string:"http://")!
    internal var  session : URLSession
    
    //MARK : methods
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    func translate( textToTranslate:String, callback: @escaping( Result<TranslatorResponse,NetworkError>)->Void) {
        
        
        guard let url = buildUrl(baseUrl:"https://api-free.deepl.com/v2/translate",
        Items:[["name":"auth_key","value":""],
               ["name":"text","value":"\(textToTranslate)"],
               ["name":"target_lang","value":"FR"]])  else{
            callback(.failure(.badUrl))
            return
            
        }
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

// MARK: decodable struct
struct Translation: Decodable {
    let detectedSourceLanguage: String
    let text : String
    
    enum CodingKeys: String, CodingKey {
        case detectedSourceLanguage = "detected_source_language"
        case text = "text"
    }
}
struct Translations: Decodable {
    
    let translations: [Translation]
    
}
// MARK: - TranslatorResponse Structure
struct TranslatorResponse: Decodable {
    let translations : [Translation]
    
}
