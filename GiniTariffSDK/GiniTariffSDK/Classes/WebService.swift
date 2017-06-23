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
    let body:Data?
    let maxRetries = 2          // original attempt + 2 retries = 3 requests in total
    let parseData: (Data) -> A?
    let parseError: (Data) -> Error?
}

extension Resource {
    
    init(url: URL, parseJSON: @escaping (Any) -> A?, parseError: @escaping (Any) -> Error?) {
        self.url = url
        self.headers = [:]
        method = "GET"
        self.body = nil
        self.parseData = { data in
            let json = Resource.jsonFrom(data: data)
            return json.flatMap(parseJSON)
        }
        self.parseError = { data in
            let json = Resource.jsonFrom(data: data)
            return json.flatMap(parseError)
        }
    }
    
    init(url: URL, headers: Dictionary<String, String>, method: String?, body: Data?, parseJSON: @escaping (Any) -> A?, parseError: @escaping (Any) -> Error?) {
        self.url = url
        self.headers = headers
        self.method = method
        self.body = body
        self.parseData = { data in
            let json = Resource.jsonFrom(data: data)
            return parseJSON(json ?? [:])
        }
        self.parseError = { data in
            let json = Resource.jsonFrom(data: data)
            return json.flatMap(parseError)
        }
    }
    
    static fileprivate func jsonFrom(data:Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}

extension Resource: Equatable {
    
    static func ==(lhs: Resource, rhs: Resource) -> Bool {
        return (lhs.url == rhs.url) && (lhs.headers == rhs.headers) && (lhs.method == rhs.method) && (lhs.body == rhs.body)
    }
}

/*
 * A networking layer inspired by objc.io and their Swift Talk episode (https://github.com/objcio/S01E01-networking/blob/master/Networking.playground/Contents.swift)
 */

protocol WebService {
    
    func load<A>(resource: Resource<A>, completion: @escaping (A?, Error?) -> ())
}

final class UrlSessionWebService : WebService {
    
    func load<A>(resource: Resource<A>, completion: @escaping (A?, Error?) -> ()) {
        tryLoad(resource: resource, completion: completion, attemptNumber: 1)
    }
    
    func tryLoad<A>(resource: Resource<A>, completion: @escaping (A?, Error?) -> (), attemptNumber:Int) {
        var request = URLRequest(url: resource.url)
        if let method = resource.method {
            request.httpMethod = method
        }
        request.httpBody = resource.body
        for (header, value) in resource.headers {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        URLSession.shared.dataTask(with: request) { [weak self](data, response, error) in
            // first check if there's an error in the response body
            if let nsError = error as NSError?,
                nsError.isRetriableError(),
                attemptNumber <= resource.maxRetries {
                // retry the request
                self?.tryLoad(resource: resource, completion: completion, attemptNumber:attemptNumber + 1)
                return
            }
            guard let data = data else {
                completion(nil, error)
                return
            }
            let responseError = resource.parseError(data)
            guard responseError == nil else {
                completion(nil, responseError)
                return
            }
            // then try to parse the response
            let responseObject = resource.parseData(data)
            if let parsedData = responseObject {
                completion(parsedData, nil)
            }
            else {
                // return an "invalid JSON" error
                let parseError = NSError(errorCode: .invalidResponse)
                completion(nil, parseError)
            }
            }.resume()
    }
    
}
