//
//  TariffSdkTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 08.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class TariffSdkTests: XCTestCase {
    
    let testClientId = "myTariffFun"
    let testClientSecret = "myTariffSecret"
    let testDomain = "tarifffun.com"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCanInitTariffSdk() {
        let sdk = emptySdk()
        XCTAssertNotNil(sdk, "Should be able to init a TariffSDK without parameters")
    }
    
    func testCanInitTariffSdkWithParameters() {
        let sdk = sdkWithParams()
        XCTAssertNotNil(sdk, "Should be able to init a TariffSDK with parameters")
    }
    
    func testHasClientId() {
        let sdk = sdkWithParams()
        XCTAssertEqual(sdk.clientId, testClientId, "TariffSDK should have a clientID property")
    }
    
    func testHasClientSecret() {
        let sdk = sdkWithParams()
        XCTAssertEqual(sdk.clientSecret, testClientSecret, "TariffSDK should have a Secret property")
    }
    
    func testHasClientDomain() {
        let sdk = sdkWithParams()
        XCTAssertEqual(sdk.clientDomain, testDomain, "TariffSDK should have a Domain property")
    }
    
    func testHasDelegate() {
        let sdk = emptySdk()
        sdk.delegate = self
        XCTAssertTrue(sdk.delegate === self, "Should be able to set TariffSDK's delegate")
    }
    
}

// Tariff SDK initialization
extension TariffSdkTests {
    
    func emptySdk() -> TariffSdk {
        return TariffSdk()
    }
    
    func sdkWithParams() -> TariffSdk {
        return TariffSdk(clientId: testClientId, clientSecret: testClientSecret, domain: testDomain)
    }
}

extension TariffSdkTests: TariffSdkDelegate {
    
    func tariffSdkDidStart(sdk:TariffSdk) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didCapture image:UIImage) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didUpload image:UIImage) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didReview image:UIImage) {
        
    }
    
    func tariffSdkDidExtractionsComplete(sdk:TariffSdk) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didExtractInfo info:NSData) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didReceiveError error:Error) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didFailWithError error:Error) {
        
    }
    
}
