//
//  PagesResponseTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class PagesResponseTests: XCTestCase {
    
    let href = "testHref"
    var response:PagesResponse! = nil
    let jsonDecoder = JSONDecoder()
    
    var testJson: String {
        return """
        {
        "_links": {
            "self": {
                "href": "\(href)"
            }
        }
        }
        """
    }
    
    func testHasHref() {
        response = try? jsonDecoder.decode(PagesResponse.self, from: testJson.data(using: .utf8)!)
        XCTAssertEqual(response.links.selfLink?.href, href, "PagesResponse should have an href field")
    }
    
    func testDictionaryWithoutHref() {
        let testJson = "{\"invalid\":\"format\"}"
        response = try? jsonDecoder.decode(PagesResponse.self, from: testJson.data(using: .utf8)!)
        XCTAssertNil(response, "Response should be nil if it's not present in the dictionary")
    }
    
}
