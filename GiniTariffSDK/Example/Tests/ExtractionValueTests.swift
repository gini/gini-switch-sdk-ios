//
//  ExtractionValueTests.swift
//  GiniTariffSDK
//
//  Created by Gini GmbH on 15.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ExtractionValueTests: XCTestCase {
    
    let extraction = ExtractionValue(value:11.34 as AnyObject, unit:"sample data")
    
    func testHasAccessValue() {
        XCTAssertEqual(extraction.value as? Double, 11.34, "ExtractionValue objects should have a value property")
    }
    
    func testHasUnit() {
        XCTAssertEqual(extraction.unit, "sample data", "Token objects should have a unit property")
    }
    
    func testInitFromDictionary() {
        let dict:JSONDictionary = ["value": Float(123.121) as AnyObject, "unit": "myUnit" as AnyObject]
        let dictExtraction = ExtractionValue(dictionary: dict)
        XCTAssertNotNil(dictExtraction, "Should be able to initialize an ExtractionValue from a dictionary")
    }
    
    func testUnitIsOptional() {
        let dict:JSONDictionary = ["value": Float(123.121) as AnyObject]
        let dictExtraction = ExtractionValue(dictionary: dict)
        XCTAssertNotNil(dictExtraction, "Should be able to initialize an ExtractionValue from a dictionary without a unit")
    }
    
}
