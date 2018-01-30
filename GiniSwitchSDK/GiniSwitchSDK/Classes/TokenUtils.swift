//
//  TokenUtils.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.06.17.
//
//

import Foundation

extension Token {
    
    func bearerAuthHeader() -> String {
        return Token.bearerAuthHeaderWith(token: accessToken)
    }
    
    func bearerAuthHeadersDict() -> [String: String] {
        return ["Authorization": bearerAuthHeader(), "Content-Type": "application/json"]
    }
    
    static func bearerAuthHeaderWith(token:String) -> String {
        return "Bearer \(token)"
    }
    
    static func bearerAuthHeadersDictWith(token:String) -> [String: String] {
        return ["Authorization": bearerAuthHeaderWith(token: token),
                "Content-Type": "application/json",
                "Accept": "application/json"]
    }
}
