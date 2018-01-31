//
//  ExtractionValueTests.swift
//  GiniSwitchSDK_Tests
//
//  Created by Nikola Sobadjiev on 24.01.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

final class ExtractionValueTests: XCTestCase {
    
    func testAddressProperties() {
        let extraction = createExtraction()
        XCTAssertEqual(extraction.value?.name, "testName", "Contract address name mismatched")
        XCTAssertNil(extraction.value?.city, "Contract address city should be nil")
        XCTAssertEqual(extraction.value?.street?.streetNumber, "23A", "Contract address street number mismatched")
    }
    
    func testStreetStringValue() {
        let extraction = createExtraction()
        XCTAssertEqual(extraction.value?.street?.valueString, "23A", "If the street name is missing it should be omitted")
    }
    
    func testAddressStringValue() {
        let extraction = createExtraction()
        XCTAssertEqual(extraction.value?.valueString, "testName, 23A, 80366", "The address striing should omit missing fields")
    }

}

extension ExtractionValueTests {
    
    func createExtraction() -> Extraction<ContractAddressValue> {
        let extraction = Extraction<ContractAddressValue>()
        let address = AddressValue(streetName: nil, streetNumber: "23A")
        let addressValue = ContractAddressValue(name: "testName", city: nil, postalCode: "80366", country: nil, street: address)
        extraction.value = addressValue
        return extraction
    }
}
