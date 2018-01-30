//
//  CreateOrderResponseTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

final class CreateOrderResponseTests: XCTestCase {
    
    let selfHref = "testSelf"
    let pagesHref = "myPages"
    var response:CreateOrderResponse! = nil
    let testDecoder = JSONDecoder()
    
    func testInitWithDict() {
        let testJSON =
        """
        {
            "_links": {
                "self": {
                    "href": "\(selfHref)"
                },
                "pages": {
                    "href": "\(pagesHref)"
                },
            },
            "extractionsComplete": false
        }
        """
        response = try? testDecoder.decode(CreateOrderResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertEqual(response.links.selfLink?.href, selfHref, "CreateOrderResponse should be able to parse the href from a JSON")
        XCTAssertEqual(response.links.pages?.href, pagesHref, "CreateOrderResponse should be able to parse the pages href from a JSON")
    }
    
    func testEmptyDictionary() {
        let testJSON = ""
        response = try? testDecoder.decode(CreateOrderResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertNil(response, "CreateOrderResponse should be nil if it's not present in the JSON")
    }
    
    func testDictionaryWithoutHref() {
        let testJSON =
        """
        {
            "myJson": "fun"
        }
        """
        response = try? testDecoder.decode(CreateOrderResponse.self, from: testJSON.data(using: .utf8)!)
        XCTAssertNil(response, "CreateOrderResponse should be nil if it's not present in the JSON")
    }
    
}
