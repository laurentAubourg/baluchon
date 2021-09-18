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
    var currentLang = "FR"
    let languageArray = [
        ["name":"Bulgarian","short":"BG"],
        ["name":"Czech","short":"CS"],
        ["name":"Danish","short":"DA"],
        ["name":"Dutch","short":"NL"],
        ["name":"English (American)","short":"EN-US"],
        ["name":"English (British)","short":"EN-GB"],
        ["name":"Estonian (British)","short":"ET"],
        ["name":"Finnish","short":"FI"],
        ["name":"French","short":"FR"],
        ["name":"German","short":"DE"],
        ["name":"Greek","short":"EL"],
        ["name":"Hungarian","short":"HU"],
        ["name":"Italian","short":"IT"],
        ["name":"Japanese","short":"JA"],
        ["name":"Lithuanian","short":"LT"],
        ["name":"Polish","short":"PL"],
        ["name":"Portuguese (Brazilian)","short":"PT-BR"],
        ["name":"Portuguese (European)","short":"PT-PT"],
        ["name":"Romania","short":"RO"],
        ["name":"Spanish","short":"SP"]
    ]
    var baseUrl:String = "https://api-free.deepl.com/v2/translate"

    var lastUrl:URL = URL(string:"http://")!
    internal var  session : URLSession
    
    //MARK : methods
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
       
        
    }
    
    func translate( textToTranslate:String, callback: @escaping( Result<TranslatorResponse,NetworkError>)->Void) {
        
        let queryItem:[[String:String]] = [["name":"auth_key","value":"\(idKey)"],
                                           ["name":"text","value":"\(textToTranslate)"],
                                           ["name":"target_lang","value":"\(currentLang)"]]
       
        guard let url = buildUrl(baseUrl:baseUrl,
                                 Items:queryItem)  else{
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
