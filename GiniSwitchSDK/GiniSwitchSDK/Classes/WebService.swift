//
//  WebService.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 30.05.17.
//
//

import UIKit

public typealias JSONDictionary = [String: Any?]

enum HTTPMethod : String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
    case HEAD = "HEAD"
}

struct Resource<A : Decodable> {
    let url: URL
    let headers: Dictionary<String, String>
    let method:HTTPMethod
    let body:Data?
    let maxRetries = 2          // original attempt + 2 retries = 3 requests in total
    let parseError: (Data) -> Error?
}

extension Resource {
    
    init(url: URL, parseError: @escaping (Any) -> Error?) {
        self.url = url
        self.headers = [:]
        method = .GET
        self.body = nil
        self.parseError = { data in
            let json = Resource.jsonFrom(data: data)
            return json.flatMap(parseError)
        }
    }
    
    init(url: URL, headers: Dictionary<String, String>, method: HTTPMethod, body: Data?, parseError: @escaping (Any) -> Error?) {
        self.url = url
        self.headers = headers
        self.method = method
        self.body = body
        self.parseError = { data in
            let json = Resource.jsonFrom(data: data)
            return json.flatMap(parseError)
        }
    }
    
    static fileprivate func jsonFrom(data:Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
    
    static fileprivate func resourceFrom(data:Data) -> A? {
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode(A.self, from: data)
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
        request.httpMethod = resource.method.rawValue
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
            let responseObject = Resource<A>.resourceFrom(data: data)
            if let parsedData = responseObject {
                completion(parsedData, nil)
            }
            else {
                // return an "invalid JSON" error
                let parseError = data.isEmpty ? nil : NSError(errorCode: .invalidResponse)
                completion(nil, parseError)
            }
            }.resume()
    }
    
}
