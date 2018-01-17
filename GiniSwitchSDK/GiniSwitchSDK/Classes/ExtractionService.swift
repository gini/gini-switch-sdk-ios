//
//  ExtractionService.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.06.17.
//
//

import UIKit

// callbacks

typealias ExtractionServiceOrderCallback = (_ url:String?, _ error:Error?) -> Void
typealias ExtractionServicePageCallback = (_ id:String?, _ error:Error?) -> Void
typealias ExtractionServiceStatusCallback = (_ status:ExtractionStatusResponse?, _ error:Error?) -> Void    // TODO: should ExtractionStatusResponse be exposed?
typealias ExtractionServiceExtractionsCallback = (_ collection:ExtractionCollection?, _ error:Error?) -> Void
typealias ExtractionServiceFeedbackCallback = (_ error:Error?) -> Void

class ExtractionService {
    
    let token:String
    let resources:ExtractionResources
    var resourceLoader:WebService       // var so a new object can be injected
    var orderUrl:String? = nil
    
    var hasExtractionOrder:Bool {
        return (orderUrl != nil)
    }
    
    init(token:String) {
        self.token = token
        resources = ExtractionResources(token: token)
        resourceLoader = UrlSessionWebService()
    }
    
    func createOrder(completion:@escaping ExtractionServiceOrderCallback) {
        resourceLoader.load(resource: resources.createExtractionOrder) { [weak self] (response, error) in
            self?.orderUrl = response?.links.selfLink?.href
            completion(self?.orderUrl, error)
        }
    }
    
    func addPage(data:Data, completion:@escaping ExtractionServicePageCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            return
        }
        resourceLoader.load(resource: resources.addPage(imageData: data, toOrder: order)) { (response, error) in
            completion(response?.links.selfLink?.href, error)
        }
    }
    
    func deletePage(id:String, completion:@escaping ExtractionServicePageCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            return
        }
        resourceLoader.load(resource: resources.deletePageWith(id: id, orderUrl: order)) { (deleted, error) in
                completion(id, error)
        }
    }
    
    func replacePage(id:String, newImageData:Data, completion:@escaping ExtractionServicePageCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            return
        }
        resourceLoader.load(resource: resources.replacePageWith(id: id, orderUrl: order, imageData: newImageData)) { (response, error) in
            completion(id, error)
        }
    }
    
    func fetchOrderStatus(completion:@escaping ExtractionServiceStatusCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            return
        }
        resourceLoader.load(resource: resources.statusFor(orderUrl: order)) { (status, error) in
            completion(status, error)
        }
    }
    
    func fetchExtractions(completion:@escaping ExtractionServiceExtractionsCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            return
        }
        resourceLoader.load(resource: resources.extractionsFor(orderUrl: order)) { (collection, error) in
            completion(collection, error)
        }
    }
    
    func sendFeedback(_ feedback:ExtractionCollection, completion:@escaping ExtractionServiceFeedbackCallback) {
        guard let order = orderUrl else {
            // no extraction order anymore
            return
        }
        resourceLoader.load(resource: resources.feebackFor(orderUrl: order, feedback: feedback)) { (response, error) in
            completion(error)
        }
    }

}
