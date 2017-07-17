//
//  GiniSwitchSdkTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class GiniSwitchSdkTests: XCTestCase {
    
    let testClientId = "myTariffFun"
    let testClientSecret = "myTariffSecret"
    let testDomain = "tarifffun.com"
    
    func testCanInitTSwitchSdk() {
        let sdk = emptySdk()
        XCTAssertNotNil(sdk, "Should be able to init a TariffSDK without parameters")
    }
    
    func testCanInitSwitchSdkWithParameters() {
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
extension GiniSwitchSdkTests {
    
    func emptySdk() -> GiniSwitchSdk {
        return GiniSwitchSdk()
    }
    
    func sdkWithParams() -> GiniSwitchSdk {
        return GiniSwitchSdk(clientId: testClientId, clientSecret: testClientSecret, domain: testDomain)
    }
}

extension GiniSwitchSdkTests: GiniSwitchSdkDelegate {
    
    func tariffSdkDidStart(sdk:GiniSwitchSdk) {
        
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didCapture imageData:Data) {
        
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didUpload imageData:Data) {
        
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didReview imageData:Data) {
        
    }
    
    func tariffSdkDidComplete(sdk:GiniSwitchSdk) {
        
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didExtractInfo info:ExtractionCollection) {
        
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didReceiveError error:Error) {
        
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didFailWithError error:Error) {
        
    }
    
    func tariffSdkDidCancel(sdk: GiniSwitchSdk) {
        
    }
    
}
