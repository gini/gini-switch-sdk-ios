//
//  CameraOptionsViewControllerTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 11.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class CameraOptionsViewControllerTests: XCTestCase {
    
    let storyboard = tariffStoryboard()
    var optionsController:CameraOptionsViewController! = nil
    
    override func setUp() {
        super.setUp()
        optionsController = storyboard?.instantiateViewController(withIdentifier: "CameraOptionsViewController") as? CameraOptionsViewController
        _ = optionsController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializingCameraOptionsController() {
        XCTAssertNotNil(optionsController, "CameraOptionsViewController should be able to get initialized from the storyboard")
    }
    
    func testCameraOptionsControllerHasCaptureButton() {
        XCTAssertNotNil(optionsController.captureButton as UIButton, "CameraOptionsViewController should have a button for capturing an image")
    }

    func testCameraOptionsControllerHasDoneButton() {
        XCTAssertNotNil(optionsController.doneButton as UIButton, "CameraOptionsViewController should have a done button")
    }
}
