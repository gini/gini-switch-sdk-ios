//
//  UserTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 30.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

final class UserTests: XCTestCase {
    
    var user = User()
    
    func testHasPassword() {
        user.password = "test"
        XCTAssertNotNil(user.password, "User should have an password")
    }
    
    func testHasEmail() {
        user.email = "test@gini.net"
        XCTAssertNotNil(user.email, "User should have an email")
    }
    
    func testInit() {
        user = User(email: "test@gini.net", password: "testPass")
        XCTAssertNotNil(user, "Should be able to initialize a User with parameters")
    }
    
    func testInitFromDictionary() {
        let dictUser = User(["password": "testid" as AnyObject, "email": "test@gini.net" as AnyObject])
        XCTAssertNotNil(dictUser, "Should be able to initialize a User with a dictionary")
    }
    
}
