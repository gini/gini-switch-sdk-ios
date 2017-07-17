//
//  ResourceError.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 21.06.17.
//
//

///
extension Resource {
    
    static func errorJsonParser() -> (Any) -> Error? {
        return { json in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return NSError(dictionary: dictionary)
        }
    }
    
    init(url: URL, parseJSON: @escaping (Any) -> A?) {
        self.init(url: url, parseJSON: parseJSON, parseError: Resource.errorJsonParser())
    }
    
    init(url: URL, headers: Dictionary<String, String>, method: String?, body: Data?, parseJSON: @escaping (Any) -> A?) {
        self.init(url: url, headers: headers, method: method, body: body, parseJSON: parseJSON, parseError: Resource.errorJsonParser())
    }
}
