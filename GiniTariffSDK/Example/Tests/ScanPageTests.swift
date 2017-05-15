//
//  ScanPageTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 15.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ScanPageTests: XCTestCase {
    
    var page:ScanPage! = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
        XCTAssertNil(page.imageData, "The default init should initialize imageData with nil")
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

extension ScanPageTests {
    
    func testImageData() -> Data {
        let testImage = UIImage(named: "testDocument")
        return UIImageJPEGRepresentation(testImage!, 0.1)!
    }
}
