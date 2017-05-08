//
//  TariffUserInterfaceTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 08.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class TariffUserInterfaceTests: XCTestCase {
    
    var tariffUI = TariffUserInterface()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultInit() {
        XCTAssertNotNil(tariffUI)
    }
    
    func testTariffUIDefaultPresentationStyles() {
        XCTAssertEqual(tariffUI.presentationStyle, .modal, "TariffUserInterface should have a presentation style, defaulting to .modal")
    }
    
    func testCanChangePresentationStlye() {
        tariffUI.presentationStyle = .navigation
        XCTAssertEqual(tariffUI.presentationStyle, .navigation, "Should be able to change TariffUserInterface's presentation style")
    }
    
    func testCreatingInitialViewController() {
        let viewController = tariffUI.initialViewController as UIViewController
        XCTAssertNotNil(viewController, "TariffUI should return a UIViewController instance")
    }
    
    func testViewControllerForModalPresentation() {
        // if the presentation style is modal, the view controller will have to be embedded in a
        // navigation stack
        tariffUI.presentationStyle = .modal
        let viewController = tariffUI.initialViewController as? UINavigationController
        XCTAssertNotNil(viewController, "TariffUI with modal presentation style should return a UINavigationController instance")
    }
    
    func testViewControllerForNavigationPresentation() {
        // if the presentation style is modal, the view controller will have to be embedded in a
        // navigation stack
        tariffUI.presentationStyle = .navigation
        let viewController = tariffUI.initialViewController as? UINavigationController
        XCTAssertNil(viewController, "TariffUI with navigaiton presentation style should not be embedded in a navigation stack")
    }
    
}
