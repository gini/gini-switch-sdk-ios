//
//  ExtractionStatusResponseTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class ExtractionStatusResponseTests: XCTestCase {
    
    let selfHref = "testSelf"
    let pagesHref = "testPages"
    var response:ExtractionStatusResponse! = nil
    let testDecoder = JSONDecoder()
    
    var testJson: String {
        return """
        {
        "_links": {
            "self": {
                "href": "\(selfHref)"
            },
            "pages": {
                "href": "\(pagesHref)"
            }
        },
        "_embedded": {
            "pages": [
                {
                    "_links": {
                        "self": {
                            "href": "\(selfHref)"
                        }
                    },
                    "status": "failed"
                }
            ]
        },
        "extractionsComplete": false
        }
        """
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testInitWithDict() {
        response = try? testDecoder.decode(ExtractionStatusResponse.self, from: testJson.data(using: .utf8)!)
        XCTAssertEqual(response.links.selfLink?.href, selfHref, "ExtractionStatusResponse should be able to parse the href from a JSON")
        XCTAssertEqual(response.pages.count, 1, "Should have only one page")
    }
    
    func testParsingPages() {
        response = try? testDecoder.decode(ExtractionStatusResponse.self, from: testJson.data(using: .utf8)!)
        let page = response.pages.first
        XCTAssertEqual(page?.pageStatus, ScanPageStatus.failed, "ExtractionStatusResponse should be able to parse page status")
        XCTAssertEqual(page?.links.selfLink?.href, selfHref, "ExtractionStatusResponse should be able to parse page href")
    }

    func testHasExtractionCompletionFlag() {
        response = try? testDecoder.decode(ExtractionStatusResponse.self, from: testJson.data(using: .utf8)!)
        XCTAssertFalse(response.extractionsComplete, "ExtractionStatusResponse should have a flag notifying when the extractions process is completed")
    }
    
}
