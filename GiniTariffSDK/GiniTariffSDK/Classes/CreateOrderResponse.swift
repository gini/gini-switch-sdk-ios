//
//  CreateOrderResponse.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 09.06.17.
//
//

import UIKit

class CreateOrderResponse: BaseApiResponse {
    
    let pages:PagesResponse
    
    override init(dict: JSONDictionary) {
        pages = PagesResponse(dict: dict)
        super.init(dict: dict)
    }

}
