//
//  ExtractionResourcesTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 08.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ExtractionResourcesTests: XCTestCase {
    
    let token = "testToken"
    var service = ExtractionResources()
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSettingToken() {
        service.token = token
        XCTAssertEqual(service.token, token, "ExtractionsService should have a token property")
    }
    
    func testInitializingWithToken() {
        service = ExtractionResources(token: token)
        XCTAssertNotNil(service, "ExtractionsService should have an initializer taking a token as parameter")
    }
    
    func testCreatingExtractionOrder() {
        service.token = token
        let orderResource = service.createExtractionOrder
        XCTAssertEqual(orderResource.url, URL(string: "https://switch.gini.net/extractionOrders"), "The create extraction order request URL doesn't match")
        XCTAssertEqual(orderResource.method, "POST", "The create extraction order request method doesn't match")
        XCTAssertNil(orderResource.body, "The extraction order request shouldn't have a body")
        XCTAssertEqual(orderResource.headers["Authorization"], "Bearer \(token)", "The extraction order request should have a bearer authentication header")
    }
    
    func testAddingPage() {
        service.token = token
        let imageData = testImageData()
        let testOrder = "myFirstOrder"
        let pageResource = service.addPage(imageData: imageData, toOrder: testOrder)
        XCTAssertEqual(pageResource.url, URL(string: "https://switch.gini.net/extractionOrders/\(testOrder)/pages"), "The add page request URL doesn't match")
        XCTAssertEqual(pageResource.method, "POST", "The add page request method doesn't match")
        XCTAssertEqual(pageResource.body, String(data: imageData, encoding: .utf8), "The add page request should have the image data as body")
        XCTAssertEqual(pageResource.headers["Authorization"], "Bearer \(token)", "The add page request should have a bearer authentication header")
        XCTAssertEqual(pageResource.headers["Content-Type"], "image/jpeg", "The add page request should have a content type header")
    }
    
    func testExtractionsStatus() {
        service.token = token
        let testOrder = "myFirstOrder"
        let extractionsResource = service.statusFor(order:testOrder)
        XCTAssertEqual(extractionsResource.url, URL(string: "https://switch.gini.net/extractionOrders/\(testOrder)"), "The extractions status request URL doesn't match")
        XCTAssertEqual(extractionsResource.method, "GET", "The extractions status request method doesn't match")
        XCTAssertNil(extractionsResource.body, "The extractions status request shouldn't have a body")
        XCTAssertEqual(extractionsResource.headers["Authorization"], "Bearer \(token)", "The extractions status request should have a bearer authentication header")
    }
    
    func testDeletePage() {
        service.token = token
        let testOrder = "myFirstOrder"
        let testPage = "myFirstPage"
        let deleteResource = service.deletePageWith(id: testPage, order:testOrder)
        XCTAssertEqual(deleteResource.url, URL(string: "https://switch.gini.net/extractionOrders/\(testOrder)/pages/\(testPage)"), "The delete page request URL doesn't match")
        XCTAssertEqual(deleteResource.method, "DELETE", "The delete page request method doesn't match")
        XCTAssertNil(deleteResource.body, "The delete page request shouldn't have a body")
        XCTAssertEqual(deleteResource.headers["Authorization"], "Bearer \(token)", "The delete page request should have a bearer authentication header")
    }
    
}
