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
    
    func testEmptyCollection() {
        XCTAssertNotNil(ExtractionCollection(), "Should be able to create empty collection")
    }
    
    func testInitWithDict() {
        extractionCollection = ExtractionCollection(dictionary: [testName:testValue])
        let extraction = extractionCollection.extractions.first
        XCTAssertEqual(extraction?.name, testName, "The key of the dictionary should match the extraction's name")
        XCTAssertEqual(extraction?.value, testValue, "The value of the dictionary should match the extraction's value")
    }
    
}
