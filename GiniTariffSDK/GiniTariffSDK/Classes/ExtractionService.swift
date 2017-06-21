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
        resourceLoader.load(resource: resources.createExtractionOrder) { [weak self] (response, error) in
            self?.orderUrl = response?.href
            completion(self?.orderUrl, error)
        }
    }
    
    func addPage(data:Data, completion:@escaping ExtractionServicePageCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.addPage(imageData: data, toOrder: order)) { (response, error) in
            completion(response?.href, error)
        }
    }
    
    func deletePage(id:String, completion:@escaping ExtractionServicePageCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.deletePageWith(id: id, orderUrl: order)) { (deleted, error) in
                completion(id, error)
        }
    }
    
    func replacePage(id:String, newImageData:Data, completion:@escaping ExtractionServicePageCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.replacePageWith(id: id, orderUrl: order, imageData: newImageData)) { (response, error) in
            completion(id, error)
        }
    }
    
    func fetchOrderStatus(completion:@escaping ExtractionServiceStatusCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.statusFor(orderUrl: order)) { (status, error) in
            // TODO: check for errors
            completion(status, error)
        }
    }
    
    func fetchExtractions(completion:@escaping ExtractionServiceExtractionsCallback) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.extractionsFor(orderUrl: order)) { (collection, error) in
            completion(collection, error)
        }
    }

}
