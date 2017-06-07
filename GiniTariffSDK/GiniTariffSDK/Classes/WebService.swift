//
//  WebService.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 30.05.17.
//
//

import UIKit

typealias JSONDictionary = [String: AnyObject?]

struct Resource<A> {
    let url: URL
    let headers: Dictionary<String, String>
    let method:String?
    let body:String?
    let parse: (Data) -> A?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.headers = [:]
        method = "GET"
        self.body = nil
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
    
    init(url: URL, headers: Dictionary<String, String>, method: String?, body: String?, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.headers = headers
        self.method = method
        self.body = body
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

/*
 * A networking layer inspired by objc.io and their Swift Talk episode (https://github.com/objcio/S01E01-networking/blob/master/Networking.playground/Contents.swift)
 */

protocol WebService {
    
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ())
}

final class UrlSessionWebService : WebService {
    
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        var request = URLRequest(url: resource.url)
        if let method = resource.method {
            request.httpMethod = method
        }
        request.httpBody = resource.body?.data(using: .utf8)
        for (header, value) in resource.headers {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
        }.resume()
    }
}
