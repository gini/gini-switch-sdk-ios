//
//  MultiPageScanViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
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
    
    override func tearDown() {
        UIApplication.shared.keyWindow?.rootViewController = nil
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
    
    func testHasMultiPageCoordinator() {
        _ = multiPageController.view
        XCTAssertNotNil(multiPageController.coordinator, "MultiPageScanViewController should have a MultiPageCoordinator")
    }
    
    func testIsMultiPageCoordinatorDelegate() {
        _ = multiPageController.view
        XCTAssertNotNil(multiPageController as MultiPageCoordinatorDelegate, "MultiPageScanViewController should conform to MultiPageCoordinatorDelegate")
        XCTAssertTrue(multiPageController.coordinator.delegate === multiPageController, "MultiPageScanViewController should be the coordinator's delegate")
    }
    
    func testPresentingViewControllerViaDelegate() {
        let testController = UIViewController()
        _ = multiPageController.view
        // the view controller needs to be added to a window, otherwise presenting will fail
        UIApplication.shared.keyWindow?.rootViewController = multiPageController
        multiPageController.multiPageCoordinator(multiPageController.coordinator, requestedShowingController: testController, presentationStyle: .modal, animated: false, completion: nil)
        XCTAssertNotNil(multiPageController.presentedViewController, "MultiPageScanViewController should present view controllers provided via the multiPageCoordinator(requestedShowingController:) method")
    }
    
    func testPrefersNoStatusBar() {
        XCTAssertTrue(multiPageController.prefersStatusBarHidden, "MultiPageScanViewController shouldn't show the status bar")
    }
    
}
