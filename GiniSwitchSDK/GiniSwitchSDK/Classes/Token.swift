//
//  Token.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 30.05.17.
//
//

import UIKit

struct Token {
    
    let accessToken:String
    let refreshToken:String?
    let expiration:Int
    
    init(accessToken:String, refreshToken: String?, expiration: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiration = expiration
    }
    
    init?(_ dictionary:JSONDictionary) {
        guard let access = dictionary["access_token"] as? String,
            let expirationTime = dictionary["expires_in"] as? Int else {
                return nil
        }
        let refresh = dictionary["refresh_token"] as? String    // the refresh token is not mandatory
        self.init(accessToken: access, refreshToken: refresh, expiration: expirationTime)
    }
    
}
