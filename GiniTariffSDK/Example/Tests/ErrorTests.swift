//
//  ErrorTests.swift
//  GiniTariffSDK
//
//  Created by Gini GmbH on 21.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class ErrorTests: XCTestCase {
    
    let errorName = "my API error"
    let errorDesc = "I'm so sorry"
    var error:NSError! = nil
    
    func testInitWithDictionary() {
        let apiErrorDict = testApiError()
        error = NSError(dictionary: apiErrorDict)
        XCTAssertEqual(error.domain, TariffErrorDomain, "All Tariff errors should have the Tariff domain")
    }
    
    func testErrorCode() {
        let apiErrorDict = testApiError()
        error = NSError(dictionary: apiErrorDict)
        XCTAssertEqual(error.code, TariffErrorCode.tokenExpired.rawValue, "An error code of 401 should correspond to an expired token")
    }
    
    func testErrorDescription() {
        let apiErrorDict = testApiError()
        error = NSError(dictionary: apiErrorDict)
        XCTAssertEqual(error.errorName(), errorName, "The error name should be the error field in the JSON")
    }
    
    func testErrorReason() {
        let apiErrorDict = testApiError()
        error = NSError(dictionary: apiErrorDict)
        XCTAssertEqual(error.errorReason(), errorDesc, "The error reason should be the error description field in the JSON")
    }
    
    func testUnderlyingError() {
        let apiErrorDict = testApiError()
        let underlyingError = NSError(dictionary: apiErrorDict)
        error = NSError(errorCode:.unknown, underlyingError:underlyingError)
        XCTAssertEqual(error.underlyingError() as NSError?, underlyingError, "The error should hold a reference to the underlying error that caused it")
    }
    
}

extension ErrorTests {
    
    func testApiError() -> JSONDictionary {
        return ["error": errorName as AnyObject, "status": 401 as AnyObject, "error_description": errorDesc as AnyObject]
    }
}
