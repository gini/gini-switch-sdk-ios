//
//  GiniSwitchSdkTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class GiniSwitchSdkTests: XCTestCase {
    
    let testClientId = "myTariffFun"
    let testClientSecret = "myTariffSecret"
    let testDomain = "tarifffun.com"
    
    func testCanInitTSwitchSdk() {
        let sdk = emptySdk()
        XCTAssertNotNil(sdk, "Should be able to init a GiniSwitchSDK without parameters")
    }
    
    func testCanInitSwitchSdkWithParameters() {
        let sdk = sdkWithParams()
        XCTAssertNotNil(sdk, "Should be able to init a GiniSwitchSDK with parameters")
    }
    
    func testHasClientId() {
        let sdk = sdkWithParams()
        XCTAssertEqual(sdk.clientId, testClientId, "GiniSwitchSDK should have a clientID property")
    }
    
    func testHasClientSecret() {
        let sdk = sdkWithParams()
        XCTAssertEqual(sdk.clientSecret, testClientSecret, "GiniSwitchSDK should have a Secret property")
    }
    
    func testHasClientDomain() {
        let sdk = sdkWithParams()
        XCTAssertEqual(sdk.clientDomain, testDomain, "GiniSwitchSDK should have a Domain property")
    }
    
    func testHasDelegate() {
        let sdk = emptySdk()
        sdk.delegate = self
        XCTAssertTrue(sdk.delegate === self, "Should be able to set GiniSwitchSDK's delegate")
    }
    
    func testCanInstantiateUi() {
        let sdk = emptySdk()
        let initialController = sdk.instantiateSwitchViewController()
        XCTAssertNotNil(initialController, "GiniSwitchSDK should be able to generate view controllers for clients")
    }
    
    func testHasConfiguration() {
        let sdk = emptySdk()
        XCTAssertNotNil(sdk.configuration, "GiniSwitchSDK should have an Configuration object")
    }
    
}

// Switch SDK initialization
extension GiniSwitchSdkTests {
    
    func emptySdk() -> GiniSwitchSdk {
        return GiniSwitchSdk()
    }
    
    func sdkWithParams() -> GiniSwitchSdk {
        return GiniSwitchSdk(clientId: testClientId, clientSecret: testClientSecret, domain: testDomain)
    }
}

extension GiniSwitchSdkTests: GiniSwitchSdkDelegate {
    
    func switchSdkDidComplete(_ sdk:GiniSwitchSdk) {
        
    }
    
    func switchSdk(_ sdk:GiniSwitchSdk, didChangeExtractions info:ExtractionCollection) {
        
    }
    
    func switchSdk(_ sdk:GiniSwitchSdk, didReceiveError error:NSError) {
        
    }
    
    func switchSdkDidCancel(_ sdk: GiniSwitchSdk) {
        
    }
    
    func switchSdkDidSendFeedback(_ sdk:GiniSwitchSdk) {
        
    }
    
}
