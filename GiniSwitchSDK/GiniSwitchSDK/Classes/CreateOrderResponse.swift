//
//  CreateOrderResponse.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//
//

import UIKit

struct CreateOrderResponse: Codable {
    
    let links:ResponseLinks
    let extractionsComplete:Bool
    
    private enum CodingKeys : String, CodingKey {
        case links = "_links"
        case extractionsComplete = "extractionsComplete"
    }
    
}
