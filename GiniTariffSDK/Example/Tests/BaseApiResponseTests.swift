//
//  BaseApiResponseTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 09.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class BaseApiResponseTests: XCTestCase {
    
    let href = "testHref"
    var response:BaseApiResponse! = nil
    
    func testHasHref() {
        response = BaseApiResponse(href: href)
        XCTAssertEqual(response.href, href, "BaseApiResponse should have an href field")
    }
    
    func testInitWithDictionary() {
        let testDict:JSONDictionary = ["_links": ["self": ["href": href]] as AnyObject]
        response = BaseApiResponse(dict: testDict)
        XCTAssertEqual(response.href, href, "BaseApiResponse should be able to parse the href from a dictionary")
    }
    
    func testEmptyDictionary() {
        let testDict:JSONDictionary = [:]
        response = BaseApiResponse(dict: testDict)
        XCTAssertNotNil(response, "href is an optional field - BaseApiResponse should be non nil even without it")
    }
    
    func testDictionaryWithoutHref() {
        let testDict:JSONDictionary = ["my": ["dictionary": "fun"] as AnyObject]
        response = BaseApiResponse(dict: testDict)
        XCTAssertNil(response.href, "href should be nil if it's not present in the dictionary")
    }
    
}
