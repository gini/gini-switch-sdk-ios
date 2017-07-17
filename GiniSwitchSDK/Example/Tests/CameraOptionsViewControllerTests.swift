//
//  CameraOptionsViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 11.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class CameraOptionsViewControllerTests: XCTestCase {
    
    let storyboard = switchStoryboard()
    var optionsController:CameraOptionsViewController! = nil
    
    // delegate variables
    var didCaptureImage = false
    var didTapOnDone = false
    
    override func setUp() {
        super.setUp()
        optionsController = storyboard?.instantiateViewController(withIdentifier: "CameraOptionsViewController") as? CameraOptionsViewController
        _ = optionsController.view
        didTapOnDone = false
        didCaptureImage = false
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
    
    func testCameraOptionsControllerHasDelegate() {
        optionsController.delegate = self
        XCTAssertTrue(optionsController.delegate === self, "CameraOptionsViewController should have a delegate")
    }
    
    func testCapturingImage() {
        optionsController.delegate = self
        optionsController.onCaptureTapped()
        XCTAssertTrue(didCaptureImage, "The didCaptureImageData: delegate method should be invoked when the capture button is tapped")
    }
    
    func testTappingOnDone() {
        optionsController.delegate = self
        optionsController.onDoneTapped()
        XCTAssertTrue(didTapOnDone, "The cameraControllerIsDone delegate method should be invoked when the done button is tapped")
    }
}

extension CameraOptionsViewControllerTests: CameraOptionsViewControllerDelegate {
    
    func cameraController(cameraController:CameraOptionsViewController, didCaptureImageData:Data) {
        didCaptureImage = true
    }
    
    func cameraControllerIsDone(cameraController:CameraOptionsViewController) {
        didTapOnDone = true
    }
    
}
