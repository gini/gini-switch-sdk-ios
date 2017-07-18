//
//  GiniSwitchAppearanceTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 26.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class GiniSwitchAppearanceTests: XCTestCase {
    
    var appearance:GiniSwitchAppearance! {
        return GiniSwitchSdkStorage.activeSwitchSdk?.appearance
    }
    let storyboard = switchStoryboard()
    let testColor = UIColor.green
    
    override func setUp() {
        super.setUp()
        GiniSwitchSdkStorage.activeSwitchSdk = GiniSwitchSdk()
    }
    
}
