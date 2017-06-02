//
//  UserManagerTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 31.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class UserManagerTests: XCTestCase {
    
    let id = "testId"
    let secret = "secret"
    let domain = "gini.net"
    var manager: UserManager!
    
    override func setUp() {
        super.setUp()
        manager = UserManager(clientId:id, clientSecret:secret, clientDomain:domain)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreatingUserManager() {
        XCTAssertNotNil(UserManager(), "Should be able to create a UserManager without parameters")
    }
    
    func testCreateWithClientCreds() {
        
        XCTAssertEqual(manager.clientId, id, "UserManager should have a client id")
        XCTAssertEqual(manager.clientSecret, secret, "UserManager should have a client secret")
    }
    
    func testHasUser() {
        let user = manager.user
        XCTAssertNotNil(user?.email, "UserManager's user should have an email")
        XCTAssertNotNil(user?.password, "UserManager's user should have a password")
    }
    
    func testCreatingUserOnlyOnce() {
        let user = manager.user
        let user2 = manager.user
        XCTAssertEqual(user?.email, user2?.email, "UserManager should create a new user only once")
        XCTAssertEqual(user?.password, user2?.password, "UserManager should create a new user only once")
    }
    
}
