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
    let testOrderId = "testOrder"
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
        service.orderId = testOrderId
        XCTAssertEqual(service.orderId, testOrderId, "Should be able to set the orderId")
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
        service.orderId = testOrderId
        service.addPage(data:newPage)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.addPage(imageData: newPage, toOrder: service.orderId!), "ExtractionService should try to send the picture to the web service")
    }
    
    func testNotDeletingPictureWithoutOrderId() {
        injectWebService()
        service.deletePage(id:testPageId)
        XCTAssertNil(stubWebService.resource, "Without a created order, pages shouldn't be deleted from the web service")
    }
    
    func testDeletingPicture() {
        injectWebService()
        service.orderId = testOrderId
        service.deletePage(id: testPageId)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.deletePageWith(id: testPageId, order: testOrderId), "ExtractionService should try to delete the picture from the web service")
    }
    
    func testRetrievingExtractionStatus() {
        injectWebService()
        service.orderId = testOrderId
        service.fetchExtractionStatus()
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.statusFor(order: testOrderId), "ExtractionService should try to retrieve the processing status from the web service")
    }
    
}

extension ExtractionServiceTests {
    
    func injectWebService() {
        stubWebService = NoOpWebService()
        service.resourceLoader = stubWebService
    }
}
