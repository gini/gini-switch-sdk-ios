//
//  AddPageResponseTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 09.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class AddPageResponseTests: XCTestCase {
    
    let selfHref = "testLink"
    let testStatus = "processing"
    var response:AddPageResponse! = nil
    
    func testInitWithDict() {
        let testDict:JSONDictionary = ["_links": ["self": ["href": selfHref]] as AnyObject, "status": testStatus as AnyObject]
        response = AddPageResponse(dict: testDict)
        XCTAssertEqual(response.href, selfHref, "AddPageResponse should be able to parse the href from a dictionary")
        XCTAssertEqual(response.status, testStatus, "AddPageResponse should be able to parse the status from a dictionary")
    }
    
    func testEmptyDictionary() {
        let testDict:JSONDictionary = [:]
        response = AddPageResponse(dict: testDict)
        XCTAssertNil(response.href, "AddPageResponse's self href should be nil if it's not present in the dictionary")
        XCTAssertNil(response.status, "AddPageResponse's status should be nil if it's not present in the dictionary")
    }
    
    func testDictionaryWithoutHref() {
        let testDict:JSONDictionary = ["my": ["dictionary": "fun"] as AnyObject]
        response = AddPageResponse(dict: testDict)
        XCTAssertNil(response.href, "AddPageResponse's self href should be nil if it's not present in the dictionary")
        XCTAssertNil(response.status, "AddPageResponse's status should be nil if it's not present in the dictionary")
    }
    
    func testProcessingStatus() {
        let testDict:JSONDictionary = ["_links": ["self": ["href": selfHref]] as AnyObject, "status": testStatus as AnyObject]
        response = AddPageResponse(dict: testDict)
        XCTAssertEqual(response.pageStatus, .uploading, "Processing should correspond to ScanPageStatus.uploading")
    }
    
    func testFailedStatus() {
        let testDict:JSONDictionary = ["_links": ["self": ["href": selfHref]] as AnyObject, "status": "failed" as AnyObject]
        response = AddPageResponse(dict: testDict)
        XCTAssertEqual(response.pageStatus, .failed, "Failed should correspond to ScanPageStatus.failed")
    }
    
    func testProcessedStatus() {
        let testDict:JSONDictionary = ["_links": ["self": ["href": selfHref]] as AnyObject, "status": "processed" as AnyObject]
        response = AddPageResponse(dict: testDict)
        XCTAssertEqual(response.pageStatus, .analysed, "Processed should correspond to ScanPageStatus.analysed")
    }
    
    func testInvalidStatus() {
        let testDict:JSONDictionary = ["_links": ["self": ["href": selfHref]] as AnyObject, "status": "NotAStatus" as AnyObject]
        response = AddPageResponse(dict: testDict)
        XCTAssertEqual(response.pageStatus, .none, "Invalid statuses should correspond to ScanPageStatus.none")
    }
    
}
