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
    
    var createExtractionOrder:Resource<CreateOrderResponse> {
        let fullUrl = baseUrl.appendingPathComponent(extractionOrderUrlExtension)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<CreateOrderResponse>(url: fullUrl, headers: authHeaders, method: "POST", body: nil, parseJSON: { json in
            guard let orderDict = json as? JSONDictionary else { return nil }
            let orderResponse = CreateOrderResponse(dict:orderDict)
            return orderResponse
        })
    }
    
    func addPage(imageData:Data, toOrder orderUrl:String) -> Resource<Bool> {
        // TODO: Figure out how to return a failing Resource
//        guard let fullUrl = URL(string:orderUrl) else {
//            // TODO: return error
//            assertionFailure("Encountered a malformed url")
//        }
        let fullUrl = URL(string:orderUrl)!
        var authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        authHeaders["Content-Type"] = "image/jpeg"
        let body = imageData
        return Resource<Bool>(url: fullUrl, headers: authHeaders, method: "POST", body: String(data: body, encoding: .utf8), parseJSON: { (json) -> Bool? in
            // TODO: check for errors
            return true
        })
    }
    
    func statusFor(orderUrl:String) -> Resource<ExtractionStatusResponse> {
        // TODO: Figure out how to return a failing Resource
//        guard let fullUrl = URL(string:orderUrl) else {
//            // TODO: return error
//            assertionFailure("Encountered a malformed url")
//        }
        let fullUrl = URL(string:orderUrl)!
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<ExtractionStatusResponse>(url: fullUrl, headers: authHeaders, method: "GET", body: nil, parseJSON: { (json) in
            guard let statusDict = json as? JSONDictionary else { return nil }
            let statusResponse = ExtractionStatusResponse(dict:statusDict)
            return statusResponse
        })
    }
    
    func deletePageWith(id:String, orderUrl:String) -> Resource<Bool> {
        // TODO: Figure out how to return a failing Resource
//        guard let fullUrl = URL(string:orderUrl) else {
//            // TODO: return error
//            assertionFailure("Encountered a malformed url")
//        }
        var fullUrl = URL(string:orderUrl)!
        fullUrl = fullUrl.appendingPathComponent(id)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<Bool>(url: fullUrl, headers: authHeaders, method: "DELETE", body: nil, parseJSON: { (json) -> Bool? in
            // TODO: check for errors
            return true
        })
    }
}
