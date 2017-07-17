//
//  TariffAppearanceTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 26.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class TariffAppearanceTests: XCTestCase {
    
    var appearance:GiniSwitchAppearance! {
        return GiniSwitchSdkStorage.activeSwitchSdk?.appearance
    }
    let storyboard = switchStoryboard()
    let testColor = UIColor.green
    
    override func setUp() {
        super.setUp()
        GiniSwitchSdkStorage.activeSwitchSdk = GiniSwitchSdk()
    }
    
//    func testChangingBackgroundColor() {
//        appearance?.screenBackgroundColor = testColor
//        let viewController = storyboard?.instantiateInitialViewController()
//        XCTAssertEqual(viewController?.view.backgroundColor, testColor, "TariffAppearance should use UIAppearance to change the SDK view controller's background")
//    }

//    func testDefaultScreenBackground() {
//        XCTAssertEqual(appearance.screenBackgroundColor, UIColor.black, "The default screen background should be black")
//    }
    
//    func testPositiveColor() {
//        appearance.resetDefaults()
//    }
    
}
