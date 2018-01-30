//
//  ScanPageTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 15.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

final class ScanPageTests: XCTestCase {
    
    var page:ScanPage! = nil
    
    func testScanPageDefaultInit() {
        XCTAssertNotNil(ScanPage(), "ScanPage should have a default initializer")
    }
    
    func testInitializingWithImageData() {
        page = ScanPage(imageData:testImageData())
        XCTAssertNotNil(page, "ScanPage should have an init method taking a Data parameter")
    }
    
    func testInitializingWithAllData() {
        page = ScanPage(imageData:testImageData(), id: "testid", status: .uploaded)
        XCTAssertNotNil(page, "ScanPage should have an init method initializing all members")
    }
    
    func testAccessingImageData() {
        let data = testImageData()
        page = ScanPage(imageData: data)
        XCTAssertEqual(page.imageData, data, "The imageData property should hold the original data, the page was initialized with")
    }
    
    func testDefaultInitValues() {
        page = ScanPage()
        XCTAssertEqual(page.imageData.count, 0, "The default init should initialize imageData with an empty object")
        XCTAssertNil(page.thumbnail, "The default init should initialize thumbnail with nil")
    }
    
    func testScanPageHasThumbnail() {
        page = ScanPage(imageData:testImageData())
        XCTAssertNotNil(page.thumbnail, "ScanPage should have a thumbnail")
    }
    
    func testThumbnailSizeAccessible() {
        XCTAssertEqual(ScanPage.thumbSize, 100, "The default size of the thumbnail should be 100")
    }
    
    func testThumbnailHasRightSize() {
        page = ScanPage(imageData:testImageData())
        XCTAssertEqual(page.thumbnail?.size.width, 100, "ScanPage should have a thumbnail")
    }
    
    func testAccessingAllData() {
        let testData = testImageData()
        let testId = "testId"
        let testStatus = ScanPageStatus.taken
        page = ScanPage(imageData: testData, id: testId, status: testStatus)
        XCTAssertEqual(page.imageData, testData, "The imageData doesn't match the one specified in the init")
        XCTAssertEqual(page.id, testId, "The id doesn't match the one specified in the init")
        XCTAssertEqual(page.status, testStatus, "The status doesn't match the one specified in the init")
    }
    
}
