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
    var orderUrl:String? = nil
    
    init(token:String) {
        self.token = token
        resources = ExtractionResources(token: token)
        resourceLoader = UrlSessionWebService()
    }
    
    func createOrder() {
        resourceLoader.load(resource: resources.createExtractionOrder) { [weak self](response) in
            self?.orderUrl = response?.href
        }
    }
    
    func addPage(data:Data) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.addPage(imageData: data, toOrder: order)) { (response) in
            // TODO: check for errors
            // TODO: notify page uploaded
        }
    }
    
    func deletePage(id:String) {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.deletePageWith(id: id, orderUrl: order)) { (_) in
            // TODO: check for errors
        }
    }
    
    func fetchExtractionStatus() {
        guard let order = orderUrl else {
            // no extraction order yet
            // TODO: maybe return an error
            return
        }
        resourceLoader.load(resource: resources.statusFor(orderUrl: order)) { (status) in
            // TODO: check for errors
        }
    }

}
