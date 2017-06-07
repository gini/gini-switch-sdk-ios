//
//  URL+QueryParameters.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 07.06.17.
//
//

import Foundation

extension URL {
    
    func appendingQueryParameter(name:String, value:String) -> URL? {
        return appendingQueryParameters(parametersDict: [name:value])
    }
    
    func appendingQueryParameters(parametersDict:[String: String]) -> URL? {
        let queryItems = parametersDict.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url
    }
}
