//
//  ExtractionResources.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.06.17.
//
//

import UIKit

struct ExtractionResources {

    var token:String = ""
    
    let baseUrl = URL(string:"https://switch-api.gini.net")!
    
    // paths
    let extractionOrderUrlExtension = "extractionOrders"
    let addPageExtension = "pages"
    let extractionsExtension = "extractions"
    
    init() {
        
    }
    
    init(token: String) {
        self.token = token
    }
    
    var createExtractionOrder:Resource<CreateOrderResponse> {
        let fullUrl = baseUrl.appendingPathComponent(extractionOrderUrlExtension)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        // currently the API doesn't accept empty bodies. Just add an empty json
        let body = try? JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
        return Resource<CreateOrderResponse>(url: fullUrl, headers: authHeaders, method: .POST, body: body)
    }
    
    func addPage(imageData:Data, toOrder orderUrl:String) -> Resource<AddPageResponse> {
        // TODO: Figure out how to return a failing Resource
//        guard let fullUrl = URL(string:orderUrl) else {
//            // TODO: return error
//            assertionFailure("Encountered a malformed url")
//        }
        var fullUrl = URL(string:orderUrl)!
        fullUrl = fullUrl.appendingPathComponent(addPageExtension)
        var authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        authHeaders["Content-Type"] = "image/jpeg"
        let body = imageData
        return Resource<AddPageResponse>(url: fullUrl, headers: authHeaders, method: .POST, body: body)
    }
    
    func statusFor(orderUrl:String) -> Resource<ExtractionStatusResponse> {
        // TODO: Figure out how to return a failing Resource
//        guard let fullUrl = URL(string:orderUrl) else {
//            // TODO: return error
//            assertionFailure("Encountered a malformed url")
//        }
        let fullUrl = URL(string:orderUrl)!
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<ExtractionStatusResponse>(url: fullUrl, headers: authHeaders, method: .GET, body: nil)
    }
    
    func extractionsFor(orderUrl:String) -> Resource<ExtractionCollection> {
        // TODO: Figure out how to return a failing Resource
        //        guard let fullUrl = URL(string:orderUrl) else {
        //            // TODO: return error
        //            assertionFailure("Encountered a malformed url")
        //        }
        var fullUrl = URL(string:orderUrl)!
        fullUrl = fullUrl.appendingPathComponent(extractionsExtension)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<ExtractionCollection>(url: fullUrl, headers: authHeaders, method: .GET, body: nil)
    }
    
    func deletePageWith(id:String, orderUrl:String) -> Resource<NoResponse> {
        // TODO: Figure out how to return a failing Resource
//        guard let fullUrl = URL(string:orderUrl) else {
//            // TODO: return error
//            assertionFailure("Encountered a malformed url")
//        }
        let fullUrl = URL(string:id)!
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<NoResponse>(url: fullUrl, headers: authHeaders, method: .DELETE, body: nil)
    }
    
    func replacePageWith(id:String, orderUrl:String, imageData:Data) -> Resource<AddPageResponse> {
        // TODO: Figure out how to return a failing Resource
        //        guard let fullUrl = URL(string:orderUrl) else {
        //            // TODO: return error
        //            assertionFailure("Encountered a malformed url")
        //        }
        let fullUrl = URL(string:id)!
        var authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        authHeaders["Content-Type"] = "image/jpeg"
        let body = imageData
        return Resource<AddPageResponse>(url: fullUrl, headers: authHeaders, method: .PUT, body: body)
    }
    
    func feebackFor(orderUrl:String, feedback:ExtractionCollection) -> Resource<NoResponse> {
        var fullUrl = URL(string:orderUrl)!
        fullUrl = fullUrl.appendingPathComponent(extractionsExtension)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        let body = feedback.feedbackJson()
        return Resource<NoResponse>(url: fullUrl, headers: authHeaders, method: .PUT, body: body)
    }
}
