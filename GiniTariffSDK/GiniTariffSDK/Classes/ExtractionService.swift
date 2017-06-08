//
//  ExtractionService.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.06.17.
//
//

import UIKit

class ExtractionService {
    
    let token:String
    let resources:ExtractionResources
    var resourceLoader:WebService       // var so a new object can be injected
    var orderId:String? = nil
    
    init(token:String) {
        self.token = token
        resources = ExtractionResources(token: token)
        resourceLoader = UrlSessionWebService()
    }
    
    func createOrder() {
        resourceLoader.load(resource: resources.createExtractionOrder) { (_) in
            // TODO: get the order id
        }
    }
    
    func addPage(data:Data) {
        guard let order = orderId else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.addPage(imageData: data, toOrder: order)) { (_) in
            // TODO: check for errors
        }
    }
    
    func deletePage(id:String) {
        guard let order = orderId else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.deletePageWith(id: id, order: order)) { (_) in
            // TODO: check for errors
        }
    }
    
    func fetchExtractionStatus() {
        guard let order = orderId else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.statusFor(order: order)) { (_) in
            // TODO: check for errors
        }
    }

}
