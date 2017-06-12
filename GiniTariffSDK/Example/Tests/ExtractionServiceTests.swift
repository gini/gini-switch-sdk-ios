//
//  ExtractionServiceTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 08.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ExtractionServiceTests: XCTestCase {
    
    let token = "testToken"
    let testOrderUrl = "https://switch.gini.net/extractionOrders/201be303-a693-44ac-b96f-31b03313ab22"
    let testPageId = "testPage"
    var service:ExtractionService! = nil
    var stubWebService:NoOpWebService! = nil
    
    override func setUp() {
        super.setUp()
        service = ExtractionService(token: token)
    }
    
    func testExtractionServiceInit() {
        XCTAssertNotNil(service, "Should be able to construct a ExtractionService")
    }
    
    func testHasToken() {
        XCTAssertEqual(service.token, token, "ExtractionService should have a token")
    }
    
    func testHasExtractionResources() {
        XCTAssertNotNil(service.resources, "ExtractionService should have an ExtractionResources")
    }
    
    func testHasWebService() {
        XCTAssertNotNil(service.resourceLoader, "ExtractionService should have a WebService")
    }
    
    func testCanSetOrderId() {
        service.orderUrl = testOrderUrl
        XCTAssertEqual(service.orderUrl, testOrderUrl, "Should be able to set the order Url")
    }
    
    func testCreateExtractionOrder() {
        injectWebService()
        service.createOrder()
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.createExtractionOrder, "Creating an order should try to send the createExtractionOrder resource to the web service")
    }
    
    func testNotUploadingPictureWithoutOrderId() {
        injectWebService()
        let newPage = testImageData()
        service.addPage(data:newPage)
        XCTAssertNil(stubWebService.resource, "Without a created order, pages shouldn't be sent to the web service")
    }
    
    func testUploadingPicture() {
        injectWebService()
        let newPage = testImageData()
        service.orderUrl = testOrderUrl
        service.addPage(data:newPage)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.addPage(imageData: newPage, toOrder: service.orderUrl!), "ExtractionService should try to send the picture to the web service")
    }
    
    func testNotDeletingPictureWithoutOrderId() {
        injectWebService()
        service.deletePage(id:testPageId)
        XCTAssertNil(stubWebService.resource, "Without a created order, pages shouldn't be deleted from the web service")
    }
    
    func testDeletingPicture() {
        injectWebService()
        service.orderUrl = testOrderUrl
        service.deletePage(id: testPageId)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.deletePageWith(id: testPageId, orderUrl: testOrderUrl), "ExtractionService should try to delete the picture from the web service")
    }
    
    func testRetrievingExtractionStatus() {
        injectWebService()
        service.orderUrl = testOrderUrl
        service.fetchExtractionStatus()
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.statusFor(orderUrl: testOrderUrl), "ExtractionService should try to retrieve the processing status from the web service")
    }
    
}

extension ExtractionServiceTests {
    
    func injectWebService() {
        stubWebService = NoOpWebService()
        service.resourceLoader = stubWebService
    }
}
