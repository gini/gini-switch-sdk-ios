//
//  ResponseLinks.swift
//  GiniSwitchSDK
//
//  Created by Nikola Sobadjiev on 11.01.18.
//

import UIKit

public struct ResponseLinks : Codable {

    let selfLink:SelfLink?
    let pages:SelfLink?
    let href:String?
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case href = "href"
        case pages = "pages"
    }
}
