//
//  ExtractionStatusResponse.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 09.06.17.
//
//

import UIKit

class ExtractionStatusResponse: BaseApiResponse {
    
    let pages:[AddPageResponse]
    let orderPageLinks:PagesResponse
    let extractionCompleted:Bool
    
    override init(dict: JSONDictionary) {
        orderPageLinks = PagesResponse(dict: dict)
        extractionCompleted = false     // TODO: parse real value when the API is ready
        if let embedded = dict["_embedded"] as? JSONDictionary,
            let pagesArray = embedded["pages"] as? [JSONDictionary] {
            pages = pagesArray.map { (pageDict) -> AddPageResponse in
                return AddPageResponse(dict: pageDict)
            }
        }
        else {
            pages = []
        }
        super.init(dict: dict)
    }

}
