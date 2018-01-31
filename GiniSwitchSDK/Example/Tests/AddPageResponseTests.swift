//
//  AddPageResponseTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

final class AddPageResponseTests: XCTestCase {
    
    let selfHref = "testLink"
    let testStatus = "processing"
    var response:AddPageResponse! = nil
    let testDecoder = JSONDecoder()
    
    func testInitWithDict() {
        let testJSON =
        """
        {
            "_links": {
                "self": {
                    "href": "\(selfHref)"
                }
            },
            "status": "\(testStatus)"
        }
        """
        response = try? testDecoder.decode(AddPageResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertEqual(response?.links.selfLink?.href, selfHref, "AddPageResponse should be able to parse the href from a JSON")
        XCTAssertEqual(response?.status, testStatus, "AddPageResponse should be able to parse the status from a JSON")
    }
    
    func testEmptyDictionary() {
        let testJSON = ""
        response = try? testDecoder.decode(AddPageResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertNil(response, "AddPageResponse should be nil if it's not present in the JSON")
    }

    func testDictionaryWithoutHref() {
        let testJSON =
        """
        {
            "myJson": "fun"
        }
        """
        response = try? testDecoder.decode(AddPageResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertNil(response, "AddPageResponse should be nil if the JSON doesn't contain a valid response object")
    }

    func testProcessingStatus() {
        let testJSON =
        """
        {
            "_links": {
                "self": {
                    "href": "\(selfHref)"
                }
            },
            "status": "\(testStatus)"
        }
        """
        response = try? testDecoder.decode(AddPageResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertEqual(response.pageStatus, .uploading, "Processing should correspond to ScanPageStatus.uploading")
    }

    func testFailedStatus() {
        let testJSON =
        """
        {
            "_links": {
                "self": {
                    "href": "\(selfHref)"
                }
            },
            "status": "failed"
        }
        """
        response = try? testDecoder.decode(AddPageResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertEqual(response.pageStatus, .failed, "Failed should correspond to ScanPageStatus.failed")
    }

    func testProcessedStatus() {
        let testJSON =
        """
        {
            "_links": {
                "self": {
                    "href": "\(selfHref)"
                }
            },
            "status": "processed"
        }
        """
        response = try? testDecoder.decode(AddPageResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertEqual(response.pageStatus, .analysed, "Failed should correspond to processed")
    }

    func testInvalidStatus() {
        let testJSON =
        """
        {
            "_links": {
                "self": {
                    "href": "\(selfHref)"
                }
            },
            "status": "NotAStatus"
        }
        """
        response = try? testDecoder.decode(AddPageResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertEqual(response.pageStatus, .none, "Invalid statuses should correspond to ScanPageStatus.none")
    }
    
}
