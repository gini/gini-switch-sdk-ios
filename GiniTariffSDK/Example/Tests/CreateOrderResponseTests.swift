//
//  CreateOrderResponseTests.swift
//  GiniTariffSDK
//
//  Created by Gini GmbH on 09.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class CreateOrderResponseTests: XCTestCase {
    
    let selfHref = "testSelf"
    let pagesHref = "myPages"
    var response:CreateOrderResponse! = nil
    
    func testInitWithDict() {
        let testDict:JSONDictionary = ["_links": ["pages": ["href": pagesHref], "self": ["href": selfHref]] as AnyObject]
        response = CreateOrderResponse(dict: testDict)
        XCTAssertEqual(response.href, selfHref, "CreateOrderResponse should be able to parse the href from a dictionary")
        XCTAssertEqual(response.pages.href, pagesHref, "CreateOrderResponse should be able to parse the pages href from a dictionary")
    }
    
    func testEmptyDictionary() {
        let testDict:JSONDictionary = [:]
        response = CreateOrderResponse(dict: testDict)
        XCTAssertNil(response.href, "CreateOrderResponse's self href should be nil if it's not present in the dictionary")
        XCTAssertNil(response.pages.href, "CreateOrderResponse's pages link should be nil if it's not present in the dictionary")
    }
    
    func testDictionaryWithoutHref() {
        let testDict:JSONDictionary = ["my": ["dictionary": "fun"] as AnyObject]
        response = CreateOrderResponse(dict: testDict)
        XCTAssertNil(response.href, "CreateOrderResponse's self href should be nil if it's not present in the dictionary")
        XCTAssertNil(response.pages.href, "CreateOrderResponse's pages link should be nil if it's not present in the dictionary")
    }
    
}
