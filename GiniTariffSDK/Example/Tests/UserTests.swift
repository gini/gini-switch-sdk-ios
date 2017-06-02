//
//  UserTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 30.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class UserTests: XCTestCase {
    
    var user = User()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
