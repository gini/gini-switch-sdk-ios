//
//  AuthenticatorTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 07.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class AuthenticatorTests: XCTestCase {
    
    let id = "testId"
    let secret = "secret"
    let domain = "gini.net"
    var auth: Authenticator! = nil
    
    override func setUp() {
        super.setUp()
        auth = Authenticator(clientId: id, secret: secret, domain: domain, credentials: MemoryCredentialsStore())
        auth.webService = NoOpWebService()
    }
    
    func testRequestingClientToken() {
        let tokenResource = auth.createClientToken
        XCTAssertEqual(tokenResource.url, URL(string: "\(auth.baseUrl.absoluteString)/oauth/token?grant_type=client_credentials"), "The client token request URL doesn't match")
        XCTAssertEqual(tokenResource.method, "GET", "The client token request method doesn't match")
        XCTAssertNil(tokenResource.body, "The client token request shouldn't have a body")
        XCTAssertEqual(tokenResource.headers["Authorization"], "Basic dGVzdElkOnNlY3JldA==", "The client token request should have a basic authentication header")
    }
    
}
