//
//  AuthenticatorTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 07.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

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
    
    func testCreatingUser() {
        auth.clientToken = "testToken"
        let userResource = auth.createUser
        XCTAssertEqual(userResource.url, URL(string: "\(auth.baseUrl.absoluteString)/api/users"), "The create user request URL doesn't match")
        XCTAssertEqual(userResource.method, "POST", "The create user request method doesn't match")
        XCTAssertEqual(String(data: userResource.body!, encoding: .utf8), "{\n  \"password\" : \"\(auth.user?.password ?? "")\",\n  \"email\" : \"\(auth.user?.email ?? "")\"\n}", "The create user request should contain user credentials in it's payload")
        XCTAssertEqual(userResource.headers["Authorization"], "Bearer testToken", "The create user request should have a bearer authentication header")
    }
    
    func testLoggingInUser() {
        auth.user = User(email: "test@gini.net", password: "password")
        let userResource = auth.userLogin
        XCTAssertEqual(userResource.url, URL(string: "\(auth.baseUrl.absoluteString)/oauth/token?grant_type=password"), "The login user request URL doesn't match")
        XCTAssertEqual(userResource.method, "POST", "The create user request method doesn't match")
        XCTAssertEqual(String(data: userResource.body!, encoding: .utf8), "username=test@gini.net&password=password", "The login user request should contain user credentials in it's payload")
        XCTAssertEqual(userResource.headers["Authorization"], "Basic dGVzdElkOnNlY3JldA==", "The login user request should have a bearer authentication header")
    }
    
}
