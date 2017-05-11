//
//  MultiPageScanViewControllerTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 09.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class MultiPageScanViewControllerTests: XCTestCase {
    
    let storyboard = tariffStoryboard()
    var multiPageController:MultiPageScanViewController! = nil
    
    override func setUp() {
        super.setUp()
        multiPageController = storyboard?.instantiateInitialViewController() as? MultiPageScanViewController
    }

    func testAbleToCreateViewController() {
        XCTAssertNotNil(multiPageController, "MultiPageScanViewController should be the initial view controller in the Tariff storyboard")
    }
    
    func testMultiPageScanControllerHidingNavigationBar() {
        // embed in a navigation controller
        _ = UINavigationController(rootViewController: multiPageController)
        _ = multiPageController.view
        XCTAssertEqual(multiPageController.navigationController?.isNavigationBarHidden ?? false, true, "MultiPageScanViewController is designed to work without a navigation bar")
    }
    
}
