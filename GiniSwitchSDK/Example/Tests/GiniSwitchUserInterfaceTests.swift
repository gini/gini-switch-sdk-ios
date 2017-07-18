//
//  GiniSwitchUserInterfaceTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class GiniSwitchUserInterfaceTests: XCTestCase {
    
    var switchUI = GiniSwitchUserInterface()
    
    func testDefaultInit() {
        XCTAssertNotNil(switchUI)
    }
    
    func testTariffUIDefaultPresentationStyles() {
        XCTAssertEqual(switchUI.presentationStyle, .modal, " Switch User Interface should have a presentation style, defaulting to .modal")
    }
    
    func testCanChangePresentationStlye() {
        switchUI.presentationStyle = .navigation
        XCTAssertEqual(switchUI.presentationStyle, .navigation, "Should be able to change GiniSwitchUserInterface's presentation style")
    }
    
    func testCreatingInitialViewController() {
        let viewController = switchUI.initialViewController as UIViewController
        XCTAssertNotNil(viewController, "SwitchUI should return a UIViewController instance")
    }
    
    func testViewControllerForModalPresentation() {
        // if the presentation style is modal, the view controller will have to be embedded in a
        // navigation stack
        switchUI.presentationStyle = .modal
        let viewController = switchUI.initialViewController as? UINavigationController
        XCTAssertNotNil(viewController, "SwitchUI with modal presentation style should return a UINavigationController instance")
    }
    
    func testViewControllerForNavigationPresentation() {
        // if the presentation style is modal, the view controller will have to be embedded in a
        // navigation stack
        switchUI.presentationStyle = .navigation
        let viewController = switchUI.initialViewController as? UINavigationController
        XCTAssertNil(viewController, "SwitchUI with navigaiton presentation style should not be embedded in a navigation stack")
    }
    
    func testReturnsMultiPageScanController() {
        switchUI.presentationStyle = .navigation    // otherwise it would be embedded into a navigation controller
        let viewController = switchUI.initialViewController as? MultiPageScanViewController
        XCTAssertNotNil(viewController, "SwitchUI should return a MultiPageScanViewController instance")
    }
    
}
