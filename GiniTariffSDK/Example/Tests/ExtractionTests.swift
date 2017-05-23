//
//  ExtractionTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 22.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ExtractionTests: XCTestCase {
    
    var extraction:Extraction! = nil
    let testName = "email"
    let testValue = "hello@gini.net"
    
    override func setUp() {
        super.setUp()
        extraction = Extraction()
    }
    
    func testHasName() {
        extraction.name = testName
        XCTAssertEqual(extraction.name, testName, "An Extraction should have a name")
    }
    
    func testHasValue() {
        extraction.value = testValue
        XCTAssertEqual(extraction.value, testValue, "An Extraction should have a value")
    }
    
    func testInitWithParameters() {
        extraction = Extraction(name:testName, value:testValue)
        XCTAssertEqual(extraction.name, testName, "An Extraction should use the name provided in the init")
        XCTAssertEqual(extraction.value, testValue, "An Extraction should use the value provided in the init")
    }
    
}
