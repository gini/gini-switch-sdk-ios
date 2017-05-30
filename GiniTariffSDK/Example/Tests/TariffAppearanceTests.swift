//
//  TariffAppearanceTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 26.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class TariffAppearanceTests: XCTestCase {
    
    var appearance:TariffAppearance! {
        return TariffSdkStorage.activeTariffSdk?.appearance
    }
    let storyboard = tariffStoryboard()
    let testColor = UIColor.green
    
    override func setUp() {
        super.setUp()
        TariffSdkStorage.activeTariffSdk = TariffSdk()
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
