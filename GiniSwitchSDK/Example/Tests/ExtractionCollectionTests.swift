//
//  ExtractionCollectionTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class ExtractionCollectionTests: XCTestCase {
    
    var extractionCollection:ExtractionCollection! = nil
    let testName = "Lechwerke AG"
    let testEnergyMeter = "A1234"
    let testValueAlternative = "hi@gini.net"
    let extractionName = "companyName"
    let extractionEnergyMeter = "energyMeterNumber"
    
    override func setUp() {
        super.setUp()
        extractionCollection = testCollection()
    }

    func testInitWithJson() {
        XCTAssertNotNil(extractionCollection, "ExtractionCollection should be able to get parsed from a JSON")
        let extraction = extractionCollection.companyName
        XCTAssertEqual(extraction?.name, extractionName, "ExtractionCollection should be able to parse the extraction's name")
        XCTAssertEqual(extraction?.valueString, testName, "ExtractionCollection should be able to parse the extraction's value")
    }

    func testInitExtractionName() {
        let extraction = extractionCollection.energyMeterNumber
        XCTAssertEqual(extraction?.name, extractionEnergyMeter, "ExtractionCollection should be able to parse the extraction's name")
    }

    func testInitExtractionValue() {
        let extraction = extractionCollection.energyMeterNumber
        XCTAssertEqual(extraction?.valueString, testEnergyMeter, "ExtractionCollection should be able to parse the extraction's value")
    }

    // TODO: fix alternatives
//    func testInitAlternatives() {
//        let extraction = extractionCollection.energyMeterNumber
//        XCTAssertEqual(extraction?.alternatives.count, 2, "ExtractionCollection should be able to parse the extraction's alternative values")
//    }
//
//    func testinitAlternativeValue() {
//        let extraction = extractionCollection.energyMeterNumber
//        XCTAssertEqual(extraction?.alternatives.first?.valueString, testValueAlternative, "ExtractionCollection should be able to parse the extraction's alternative value")
//    }
}

extension ExtractionCollectionTests {
    
    func testCollection() -> ExtractionCollection? {
        let testJSON =
        """
        {
            "\(extractionName)" : {
                "value" : "\(testName)",
                "alternatives" : [ ]
            },
            "\(extractionEnergyMeter)" : {
                "value" : "\(testEnergyMeter)",
                "alternatives" : [ "\(testEnergyMeter)", "\(testEnergyMeter)" ]
            },
            "_links" : {
                "self" : {
                    "href" : "testRef"
                }
            }
        }
        """
        let decoder = JSONDecoder()
        return try? decoder.decode(ExtractionCollection.self, from: testJSON.data(using: .utf8)!)
    }
}
