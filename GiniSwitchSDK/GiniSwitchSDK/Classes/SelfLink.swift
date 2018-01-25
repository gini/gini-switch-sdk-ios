//
//  SelfLink.swift
//  GiniSwitchSDK
//
//  Created by Nikola Sobadjiev on 11.01.18.
//

import UIKit

struct SelfLink: Codable {

    let href:String
    
}

extension SelfLink: Equatable {
    
    static func ==(lhs: SelfLink, rhs: SelfLink) -> Bool {
        return lhs.href == rhs.href
    }
    
}
