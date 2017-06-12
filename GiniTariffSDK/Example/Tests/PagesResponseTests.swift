//
//  PagesResponseTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 09.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class PagesResponseTests: XCTestCase {
    
    let href = "testHref"
    var response:PagesResponse! = nil
    
    func testHasHref() {
        response = PagesResponse(href: href)
        XCTAssertEqual(response.href, href, "PagesResponse should have an href field")
    }
    
    func testInitWithDictionary() {
        let testDict:JSONDictionary = ["_links": ["pages": ["href": href]] as AnyObject]
        response = PagesResponse(dict: testDict)
        XCTAssertEqual(response.href, href, "PagesResponse should be able to parse the href from a dictionary")
    }
    
    func testEmptyDictionary() {
        let testDict:JSONDictionary = [:]
        response = PagesResponse(dict: testDict)
        XCTAssertNotNil(response, "href is an optional field - PagesResponse should be non nil even without it")
    }
    
    func testDictionaryWithoutHref() {
        let testDict:JSONDictionary = ["my": ["dictionary": "fun"] as AnyObject]
        response = PagesResponse(dict: testDict)
        XCTAssertNil(response.href, "href should be nil if it's not present in the dictionary")
    }
    
}
