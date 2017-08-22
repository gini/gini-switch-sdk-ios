//
//  MultiPageScanViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class MultiPageScanViewControllerTests: XCTestCase {
    
    let storyboard = switchStoryboard()
    var multiPageController:MultiPageScanViewController! = nil
    
    override func setUp() {
        super.setUp()
        multiPageController = storyboard?.instantiateInitialViewController() as? MultiPageScanViewController
    }
    
    override func tearDown() {
        UIApplication.shared.keyWindow?.rootViewController = nil
    }

    func testAbleToCreateViewController() {
        XCTAssertNotNil(multiPageController, "MultiPageScanViewController should be the initial view controller in the Switch storyboard")
    }
    
    func testMultiPageScanControllerHidingNavigationBar() {
        // embed in a navigation controller
        _ = UINavigationController(rootViewController: multiPageController)
        _ = multiPageController.view
        multiPageController.viewWillAppear(true)
        XCTAssertEqual(multiPageController.navigationController?.isNavigationBarHidden ?? false, true, "MultiPageScanViewController is designed to work without a navigation bar")
    }
    
    func testPresentingViewControllerViaDelegate() {
        let testController = UIViewController()
        _ = multiPageController.view
        // the view controller needs to be added to a window, otherwise presenting will fail
        UIApplication.shared.keyWindow?.rootViewController = multiPageController
        multiPageController.present(controller: testController, presentationStyle: .modal, animated: false, completion: nil)
        XCTAssertNotNil(multiPageController.presentedViewController, "MultiPageScanViewController should present view controllers provided via the present method")
    }
    
    func testPrefersNoStatusBar() {
        XCTAssertTrue(multiPageController.prefersStatusBarHidden, "MultiPageScanViewController shouldn't show the status bar")
    }
    
}
