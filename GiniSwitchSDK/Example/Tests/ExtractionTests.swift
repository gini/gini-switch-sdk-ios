//
//  ExtractionTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class ExtractionTests: XCTestCase {
    
    var extraction:Extraction! = nil
    let testName = "email"
    let testValue = "hello@gini.net"
    let testValueAlternative = "hi@gini.net"
    
    override func setUp() {
        super.setUp()
        extraction = Extraction(name: testName, value: testValue as AnyObject)
    }
    
    func testHasName() {
        XCTAssertEqual(extraction.name, testName, "An Extraction should have a name")
    }
    
    func testHasValue() {
        XCTAssertEqual(extraction.valueString, testValue, "An Extraction should have a value")
    }
    
    func testInitWithParameters() {
        extraction = Extraction(name:testName, value:testValue as AnyObject)
        XCTAssertEqual(extraction.name, testName, "An Extraction should use the name provided in the init")
        XCTAssertEqual(extraction.valueString, testValue, "An Extraction should use the value provided in the init")
    }
    
    func testInitWithDict() {
        extraction = Extraction(name:testName, dict:extractionDict())
        XCTAssertEqual(extraction.name, testName, "An Extraction should use the name provided in the init")
        XCTAssertEqual(extraction.valueString, testValue, "An Extraction should use the value provided in the init")
    }
    
    func testHasAlternatives() {
        extraction = Extraction(name:testName, dict:extractionDict())
        let alternative = extraction.alternatives.first
        XCTAssertEqual(alternative?.valueString, testValueAlternative, "Extraction should be able to parse the alternatives")
    }
}

extension ExtractionTests {
    
    func extractionDict() -> JSONDictionary {
        return ["value": testValue as AnyObject, "alternatives": [["value": testValueAlternative, "unit": "mails"]] as AnyObject]
    }
}
