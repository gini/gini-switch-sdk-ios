//
//  ExtractionStatusResponseTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ExtractionStatusResponseTests: XCTestCase {
    
    let selfHref = "testSelf"
    let pagesHref = "testPages"
    var response:ExtractionStatusResponse! = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitWithDict() {
        let testDict:JSONDictionary = ["_links": ["self": ["href": selfHref], "pages": ["href": pagesHref]] as AnyObject, "_embedded": ["pages": [["_links": ["self": ["href": selfHref]] as AnyObject]]] as AnyObject]
        response = ExtractionStatusResponse(dict: testDict)
        XCTAssertEqual(response.href, selfHref, "ExtractionStatusResponse should be able to parse the href from a dictionary")
        XCTAssertEqual(response.pages.count, 1, "Should have only one page")
    }
    
    func testParsingPages() {
        let testDict:JSONDictionary = ["_links": ["self": ["href": selfHref], "pages": ["href": pagesHref]] as AnyObject, "_embedded": ["pages": [["_links": ["self": ["href": selfHref]] as AnyObject, "status": "failed"]]] as AnyObject]
        response = ExtractionStatusResponse(dict: testDict)
        let page = response.pages.first
        XCTAssertEqual(page?.pageStatus, ScanPageStatus.failed, "ExtractionStatusResponse should be able to parse page status")
        XCTAssertEqual(page?.href, selfHref, "ExtractionStatusResponse should be able to parse page href")
    }
    
    func testHasExtractionCompletionFlag() {
        response = ExtractionStatusResponse(dict: [:])
        XCTAssertFalse(response.extractionCompleted, "ExtractionStatusResponse should have a flag notifying when the extractions process is completed")
    }
    
}
