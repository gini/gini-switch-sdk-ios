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
    
    func testCanInstantiateUi() {
        let sdk = emptySdk()
        let initialController = sdk.instantiateTariffViewController()
        XCTAssertNotNil(initialController, "TariffSdk should be able to generate view controllers for clients")
    }
    
    func testHasUserInterface() {
        let sdk = emptySdk()
        XCTAssertNotNil(sdk.userInterface, "TariffSdk should have a TariffUserInterface object")
    }
    
    func testHasConfiguration() {
        let sdk = emptySdk()
        XCTAssertNotNil(sdk.configuration, "TariffSdk should have a TariffConfiguration object")
    }
    
    func testHasAppearance() {
        let sdk = emptySdk()
        XCTAssertNotNil(sdk.appearance, "TariffSdk should have a TariffAppearance object")
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
    
    func tariffSdkDidCancel(sdk: TariffSdk) {
        
    }
    
}
