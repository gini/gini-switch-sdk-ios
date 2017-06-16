//
//  ExtractionService.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.06.17.
//
//

import UIKit

// callbacks

typealias ExtractionServiceOrderCallback = (_ url:String?, _ error:Error?) -> Void
typealias ExtractionServicePageCallback = (_ id:String?, _ error:Error?) -> Void
typealias ExtractionServiceStatusCallback = (_ status:ExtractionStatusResponse?, _ error:Error?) -> Void    // TODO: should ExtractionStatusResponse be exposed?
typealias ExtractionServiceExtractionsCallback = (_ collection:ExtractionCollection?, _ error:Error?) -> Void

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
        resourceLoader.load(resource: resources.createExtractionOrder) { [weak self](response) in
            self?.orderUrl = response?.href
            completion(self?.orderUrl, nil)
        }
    }
    
    func addPage(data:Data, completion:@escaping ExtractionServicePageCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.addPage(imageData: data, toOrder: order)) { (response) in
            completion(response?.href, nil)
            // TODO: check for errors
        }
    }
    
    func deletePage(id:String, completion:@escaping ExtractionServicePageCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.deletePageWith(id: id, orderUrl: order)) { (deleted) in
            if deleted == true {
                completion(id, nil)
            }
            else {
//                completion(id, Error())   // TODO: return the error
            }
        }
    }
    
    func fetchOrderStatus(completion:ExtractionServiceStatusCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.statusFor(orderUrl: order)) { (status) in
            // TODO: check for errors
        }
    }
    
    func fetchExtractions(completion:@escaping ExtractionServiceExtractionsCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.extractionsFor(orderUrl: order)) { (collection) in
            completion(collection, nil)
        }
    }

}
