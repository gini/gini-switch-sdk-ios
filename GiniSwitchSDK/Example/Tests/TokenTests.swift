//
//  TokenTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 30.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class TokenTests: XCTestCase {
    
    let token = Token(accessToken: "access", refreshToken: "refresh", expiration: 100)
    
    func testHasAccessToken() {
        XCTAssertFalse(token.accessToken.isEmpty, "Token objects should have an access token property")
    }
    
    func testHasRefreshToken() {
        XCTAssertNotNil(token.refreshToken, "Token objects should have a refresh token property")
    }
    
    func testHasExpiration() {
        XCTAssertNotEqual(token.expiration, 0, "Token objects should have an expiration period")
    }
    
    func testInitFromJson() {
        let tokenValue1 = "exampleToken1"
        let tokenValue2 = "exampleToken2"
        let tokenTTL = 123
        let testJson = """
        {
            "access_token": "\(tokenValue1)",
            "refresh_token": "\(tokenValue2)",
            "expires_in": \(tokenTTL)
        }
        """
        let decoder = JSONDecoder()
        let token = try? decoder.decode(Token.self, from: testJson.data(using: .utf8)!)
        XCTAssertEqual(token?.accessToken, tokenValue1, "The access token should be parsed from access_token")
        XCTAssertEqual(token?.refreshToken, tokenValue2, "The refresh token should be parsed from refresh_token")
        XCTAssertEqual(token?.expiration, tokenTTL, "The token expiration should be parsed from expires_in")
    }
    
}
