//
//  Token.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 30.05.17.
//
//

import UIKit

struct Token : Codable {
    
    let accessToken:String
    let refreshToken:String?
    let expiration:Int
    
    init(accessToken:String, refreshToken: String?, expiration: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiration = expiration
    }
    
    private enum CodingKeys : String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiration = "expires_in"
    }
    
}
