//
//  ExtractionCollectionTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 22.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ExtractionCollectionTests: XCTestCase {
    
    var extractionCollection:ExtractionCollection! = nil
    let testName = "email"
    let testValue = "hello@gini.net"
    let testValueAlternative = "hi@gini.net"
    let extractionName = "myExtraction"
    
    override func setUp() {
        super.setUp()
        extractionCollection = testCollection()
    }
    
    func testEmptyCollection() {
        XCTAssertNotNil(ExtractionCollection(), "Should be able to create empty collection")
    }
    
    func testInitWithDict() {
        XCTAssertNotNil(extractionCollection, "ExtractionCollection should be able to get parsed from a dictionary")
        let extraction = extractionCollection.extractions.first
        XCTAssertEqual(extraction?.name, extractionName, "ExtractionCollection should be able to parse the extraction's name")
        XCTAssertEqual(extraction?.value.valueString, testValue, "ExtractionCollection should be able to parse the extraction's value")
    }
    
    func testInitExtractionName() {
        let extraction = extractionCollection.extractions.first
        XCTAssertEqual(extraction?.name, extractionName, "ExtractionCollection should be able to parse the extraction's name")
    }
    
    func testInitExtractionValue() {
        let extraction = extractionCollection.extractions.first
        XCTAssertEqual(extraction?.value.valueString, testValue, "ExtractionCollection should be able to parse the extraction's value")
    }
    
    func testInitAlternatives() {
        let extraction = extractionCollection.extractions.first
        XCTAssertEqual(extraction?.alternatives.count, 1, "ExtractionCollection should be able to parse the extraction's alternative values")
    }
    
    func testinitAlternativeValue() {
        let extraction = extractionCollection.extractions.first
        XCTAssertEqual(extraction?.alternatives.first?.valueString, testValueAlternative, "ExtractionCollection should be able to parse the extraction's alternative value")
    }
}

extension ExtractionCollectionTests {
    
    func testDict() -> JSONDictionary {
        return [extractionName: ["value": testValue as AnyObject, "alternatives": [["value": testValueAlternative, "unit": "mails"]] as AnyObject] as AnyObject]
    }
    
    func testCollection() -> ExtractionCollection? {
        let dict = testDict()
        return ExtractionCollection(dictionary: dict)
    }
}
