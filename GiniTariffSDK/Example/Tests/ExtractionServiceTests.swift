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
    
    // callbacks
    var orderCallBack:ExtractionServiceOrderCallback!
    var pageCallBack:ExtractionServicePageCallback!
    var statusCallback:ExtractionServiceStatusCallback!
    var extractionsCallback:ExtractionServiceExtractionsCallback!
    
    // callback params
    var returnedError:Error? = nil
    var returnedId:String? = nil
    var returnedStatus:ExtractionStatusResponse? = nil
    var returnedExtractions:ExtractionCollection? = nil
    
    override func setUp() {
        super.setUp()
        service = ExtractionService(token: token)
        
        orderCallBack = { [weak self](url, error) -> Void in
            self?.returnedId = url
            self?.returnedError = error
        }
        pageCallBack = { [weak self](url, error) -> Void in
            self?.returnedId = url
            self?.returnedError = error
        }
        statusCallback = { [weak self](status, error) -> Void in
            self?.returnedStatus = status
            self?.returnedError = error
        }
        extractionsCallback = { [weak self](collection, error) -> Void in
            self?.returnedExtractions = collection
            self?.returnedError = error
        }
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
        service.createOrder(completion: orderCallBack)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.createExtractionOrder, "Creating an order should try to send the createExtractionOrder resource to the web service")
    }
    
    func testNotUploadingPictureWithoutOrderId() {
        injectWebService()
        let newPage = testImageData()
        service.addPage(data:newPage, completion: pageCallBack)
        XCTAssertNil(stubWebService.resource, "Without a created order, pages shouldn't be sent to the web service")
    }
    
    func testUploadingPicture() {
        injectWebService()
        let newPage = testImageData()
        service.orderUrl = testOrderUrl
        service.addPage(data:newPage, completion: pageCallBack)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.addPage(imageData: newPage, toOrder: service.orderUrl!), "ExtractionService should try to send the picture to the web service")
    }
    
    func testNotDeletingPictureWithoutOrderId() {
        injectWebService()
        service.deletePage(id:testPageId, completion: pageCallBack)
        XCTAssertNil(stubWebService.resource, "Without a created order, pages shouldn't be deleted from the web service")
    }
    
    func testDeletingPicture() {
        injectWebService()
        service.orderUrl = testOrderUrl
        service.deletePage(id: testPageId, completion: pageCallBack)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.deletePageWith(id: testPageId, orderUrl: testOrderUrl), "ExtractionService should try to delete the picture from the web service")
    }
    
    func testRetrievingOrderStatus() {
        injectWebService()
        service.orderUrl = testOrderUrl
        service.fetchOrderStatus(completion: statusCallback)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.statusFor(orderUrl: testOrderUrl), "ExtractionService should try to retrieve the processing status from the web service")
    }
    
    func testRetrievingExtractions() {
        injectWebService()
        service.orderUrl = testOrderUrl
        service.fetchExtractions(completion: extractionsCallback)
        XCTAssertEqual(stubWebService.resource as! Resource, service.resources.extractionsFor(orderUrl: testOrderUrl), "ExtractionService should try to retrieve the extractions from the web service")
    }
    
}

extension ExtractionServiceTests {
    
    func injectWebService() {
        stubWebService = NoOpWebService()
        service.resourceLoader = stubWebService
    }
}
