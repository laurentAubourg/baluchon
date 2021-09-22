//
//  CurrencyConverterService.swift
//  baluchon
//
//  Created by laurent aubourg on 27/08/2021.
//
//
import Foundation

class TranslatorService:UrlSessionCancelable,UrlBuildable{
    
    
    //MARK: - properties
    
    var currentLang = "FR"
    var languageArray: [Target] = [(Target(language:"",name:""))]
    var lastUrl:URL = URL(string:"http://")!
    internal var  session : URLSession
    
    //MARK: - methods
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
        getLanguageList()
        
    }
    
    // MARK: - Request to the API to ask for the translation in the selected language of the words passed in parameter
    
    func translate( textToTranslate:String, callback: @escaping( Result<TranslatorResponse,NetworkError>)->Void) {
        let baseUrl:String = "https://api-free.deepl.com/v2/translate"
        let queryItem:[[String:String]] = [["name":"auth_key","value":"\(ApiKey.deeple)"],
                                           ["name":"text","value":"\(textToTranslate)"],
                                           ["name":"target_lang","value":"\(currentLang)"]]
        
        guard let url = buildUrl(baseUrl:baseUrl, Items:queryItem)  else{
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
    
    
    // MARK : -callBack function of the API call to get the list of available languages
    
    func getLanguageList() {
        
        targetLanguages(){ [ self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success( let data):
                    
                    self.languageArray = data
                    languageArray.sort{
                        ((($0 ).name as? String)!) < ((($1 ).name as? String)!)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    // MARK: - Make a request to the API To obtain the list of available languages
    
    func targetLanguages(  callback: @escaping( Result<[Target],NetworkError>)->Void) {
        let baseUrl:String = "https://api-free.deepl.com/v2/languages"
        let queryItem:[[String:String]] = [["name":"auth_key","value":"\(ApiKey.deeple)"],
        ]
        
        guard let url = buildUrl(baseUrl:baseUrl, Items:queryItem)  else{return }
        print (url)
        
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
// MARK: - TranslatorResponse Struct

struct TranslatorResponse: Decodable {
    let translations : [Translation]
    
}

// MARK: decodable struct for languages list

struct Target: Decodable {
    let language: String
    let name : String
    //    let supportsFormality:Bool
    
    enum CodingKeys: String, CodingKey {
        case language = "language"
        case name = "name"
        //        case supportsFormality = "supports_formality"
    }
}

