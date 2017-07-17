//
//  TokenTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 30.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

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
    
    func testInitFromDictionary() {
        let dictToken = Token(["access_token": "exampleToken" as AnyObject, "refresh_token": "exampleToken" as AnyObject, "expires_in": 123 as AnyObject])
        XCTAssertNotNil(dictToken, "Should be able to initialize a Token from a dictionary")
    }
    
}
