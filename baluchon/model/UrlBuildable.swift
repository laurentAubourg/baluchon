//
//  UrlBuildable.swift
//  baluchon
//
//  Created by laurent aubourg on 15/09/2021.
//

import Foundation
protocol UrlBuildable{
    
}
extension UrlBuildable{
    func buildUrl(baseUrl:String,Items:[[String:String]])->URL?{
        var components = URLComponents(string: baseUrl)
      
        var  queryItems: [URLQueryItem] = []
        for item:[String:String] in Items {
            guard item["name"] != nil  else{
                return nil
            }
            guard item["value"] != nil  else{
                return nil
            }
            let queryItem =  URLQueryItem(name: item["name"]!, value: item["value"]!)
            queryItems.append(queryItem)
        }
        components?.queryItems = queryItems
        guard let url :URL = components?.url else{
            return nil
        }
        return url
    }
}
