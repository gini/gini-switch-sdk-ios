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
    
    var extraction:Extraction<StringValue>! = nil
    let testName = "email"
    let testValue = "hello@gini.net"
    let testValueAlternative = "hi@gini.net"
    
    override func setUp() {
        super.setUp()
        extraction = createExtraction()
    }
    
    func testHasName() {
        XCTAssertEqual(extraction.name, testName, "An Extraction should have a name")
    }
    
    func testHasValue() {
        XCTAssertEqual(extraction.valueString, testValue, "An Extraction should have a value")
    }
    
    func testHasAlternatives() {
        let alternative = extraction.alternatives.first
        XCTAssertEqual(alternative?.valueString, testValueAlternative, "Extraction should be able to parse the alternatives")
    }
}

extension ExtractionTests {
    
    func createExtraction() -> Extraction<StringValue> {
        let extraction = Extraction<StringValue>()
        extraction.name = testName
        extraction.value = StringValue(value: testValue)
        extraction.alternatives = [StringValue(value: testValueAlternative), StringValue(value: testValueAlternative)]
        return extraction
    }
}
