//
//  ExtractionResources.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.06.17.
//
//

import UIKit

class ExtractionResources {

    var token:String = ""
    
    let baseUrl = URL(string:"https://switch.gini.net")!
    
    // paths
    let extractionOrderUrlExtension = "extractionOrders"
    let addPageExtension = "pages"  // NOTE: not the complete path - the order id needs to be added before this
    
    init() {
        
    }
    
    init(token: String) {
        self.token = token
    }
    
    var createExtractionOrder:Resource<Bool> {
        let fullUrl = baseUrl.appendingPathComponent(extractionOrderUrlExtension)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<Bool>(url: fullUrl, headers: authHeaders, method: "POST", body: nil, parseJSON: { json in
            guard let _ = json as? JSONDictionary else { return nil }
            // TODO: check for errors
            return true
        })
    }
    
    func addPage(imageData:Data, toOrder extractionOrder:String) -> Resource<Bool> {
        var fullUrl = baseUrl.appendingPathComponent(extractionOrderUrlExtension)
        fullUrl = fullUrl.appendingPathComponent(extractionOrder)
        fullUrl = fullUrl.appendingPathComponent(addPageExtension)
        var authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        authHeaders["Content-Type"] = "image/jpeg"
        let body = imageData
        return Resource<Bool>(url: fullUrl, headers: authHeaders, method: "POST", body: String(data: body, encoding: .utf8), parseJSON: { (json) -> Bool? in
            // TODO: check for errors
            return true
        })
    }
    
    func statusFor(order:String) -> Resource<AnyObject> {
        var fullUrl = baseUrl.appendingPathComponent(extractionOrderUrlExtension)
        fullUrl = fullUrl.appendingPathComponent(order)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<AnyObject>(url: fullUrl, headers: authHeaders, method: "GET", body: nil, parseJSON: { (json) -> AnyObject? in
            // TODO: check for errors
            return nil
        })
    }
    
    func deletePageWith(id:String, order:String) -> Resource<Bool> {
        var fullUrl = baseUrl.appendingPathComponent(extractionOrderUrlExtension)
        fullUrl = fullUrl.appendingPathComponent(order)
        fullUrl = fullUrl.appendingPathComponent(addPageExtension)
        fullUrl = fullUrl.appendingPathComponent(id)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<Bool>(url: fullUrl, headers: authHeaders, method: "DELETE", body: nil, parseJSON: { (json) -> Bool? in
            // TODO: check for errors
            return true
        })
    }
}
