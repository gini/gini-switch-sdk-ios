//
//  ExtractionResources.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.06.17.
//
//

import UIKit

class ExtractionResources {

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
        let body = try! JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
        return Resource<CreateOrderResponse>(url: fullUrl, headers: authHeaders, method: "POST", body: body, parseJSON: { json in
            guard let orderDict = json as? JSONDictionary else { return nil }
            let orderResponse = CreateOrderResponse(dict:orderDict)
            return orderResponse
        })
    }
    
    func addPage(imageData:Data, toOrder orderUrl:String) -> Resource<AddPageResponse> {
        // TODO: Figure out how to return a failing Resource
//        guard let fullUrl = URL(string:orderUrl) else {
//            // TODO: return error
//            assertionFailure("Encountered a malformed url")
//        }
        var fullUrl = URL(string:orderUrl)!
        fullUrl = fullUrl.appendingPathComponent(addPageExtension)  // TODO: We might consider getting the full url as parameter
        var authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        authHeaders["Content-Type"] = "image/jpeg"
        let body = imageData
        return Resource<AddPageResponse>(url: fullUrl, headers: authHeaders, method: "POST", body: body, parseJSON: { (json) -> AddPageResponse? in
            guard let pageDict = json as? JSONDictionary else { return nil }
            let pageResponse = AddPageResponse(dict:pageDict)
            return pageResponse
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
    
    func extractionsFor(orderUrl:String) -> Resource<ExtractionCollection> {
        // TODO: Figure out how to return a failing Resource
        //        guard let fullUrl = URL(string:orderUrl) else {
        //            // TODO: return error
        //            assertionFailure("Encountered a malformed url")
        //        }
        var fullUrl = URL(string:orderUrl)!
        fullUrl = fullUrl.appendingPathComponent(extractionsExtension)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<ExtractionCollection>(url: fullUrl, headers: authHeaders, method: "GET", body: nil, parseJSON: { (json) in
            guard let extractionsDict = json as? JSONDictionary else { return nil }
            let extractionsResponse = ExtractionCollection(dictionary: extractionsDict)
            return extractionsResponse
        })
    }
    
    func deletePageWith(id:String, orderUrl:String) -> Resource<Bool> {
        // TODO: Figure out how to return a failing Resource
//        guard let fullUrl = URL(string:orderUrl) else {
//            // TODO: return error
//            assertionFailure("Encountered a malformed url")
//        }
        let fullUrl = URL(string:id)!
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        return Resource<Bool>(url: fullUrl, headers: authHeaders, method: "DELETE", body: nil, parseJSON: { (json) -> Bool? in
            // TODO: check for errors
            return true
        })
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
        return Resource<AddPageResponse>(url: fullUrl, headers: authHeaders, method: "PUT", body: body, parseJSON: { (json) -> AddPageResponse? in
            guard let pageDict = json as? JSONDictionary else { return nil }
            let pageResponse = AddPageResponse(dict:pageDict)
            return pageResponse
        })
    }
    
    func feebackFor(orderUrl:String, extractions:ExtractionCollection, feedback:ExtractionCollection) -> Resource<FeedbackResponse> {
        var fullUrl = URL(string:orderUrl)!
        fullUrl = fullUrl.appendingPathComponent(extractionsExtension)
        let authHeaders = Token.bearerAuthHeadersDictWith(token: token)
        let body = ExtractionCollection.feedbackJsonFor(feedback: feedback, original: extractions)
        return Resource<FeedbackResponse>(url: fullUrl, headers: authHeaders, method: "PUT", body: body, parseJSON: { (json) -> FeedbackResponse? in
            guard let feedbackDict = json as? JSONDictionary else { return nil }
            let feedbackResponse = FeedbackResponse(dict:feedbackDict)
            return feedbackResponse
        })
    }
}
