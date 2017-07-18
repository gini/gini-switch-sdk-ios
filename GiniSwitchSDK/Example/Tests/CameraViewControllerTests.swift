//
//  CameraViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class CameraViewControllerTests: XCTestCase {
  
    let storyboard = UIStoryboard.switchStoryboard()
    var cameraController:CameraViewController! = nil
    var fakeCamera:FakeCamera! = nil
    
    // delegate state variables
    var didTakePicture = false
    
    override func setUp() {
        super.setUp()
        cameraController = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController
        fakeCamera = try! FakeCamera()
        cameraController.camera = fakeCamera
        didTakePicture = false
    }
    
    func testInitializingCameraFromStoryboard() {
        XCTAssertNotNil(cameraController, "Should be able to initialize CameraViewController from the storyboard")
    }
    
    func testCameraViewControllerHasPreviewView() {
        _ = cameraController.view      // force the view to load
        let preview:CameraPreviewView? = cameraController?.cameraPreview
        XCTAssertNotNil(preview, "CameraViewController should have a preview property")
    }
    
    func testCameraViewControllerHasCamera() {
        _ = cameraController.view      // force the view to load
        XCTAssertNotNil(cameraController?.camera, "CameraViewController should have a camera property")
    }
    
    func testPreviewHasCameraSession() {
        _ = cameraController.view      // force the view to load
        XCTAssertEqual(cameraController?.cameraPreview.session, cameraController?.camera.session, "The Preview view should have the camera session set")
    }
    
    func testHasUnauthorizedView() {
        _ = cameraController.view      // force the view to load
        XCTAssertNotNil(cameraController?.unauthorizedView, "CameraViewController should have a fallback view for when there's no camera access")
    }
    
    func testCameraWasStartedWhenViewAppeared() {
        _ = cameraController.view      // force the view to load
        cameraController.viewWillAppear(false)
        cameraController.viewDidAppear(false)
        XCTAssertTrue(fakeCamera.isStarted, "The camera should be started when the view appears")
    }
    
    func testCameraWasStoppedWhenViewDisappeared() {
        _ = cameraController.view      // force the view to load
        cameraController.viewWillAppear(false)
        cameraController.viewDidAppear(false)
        cameraController.viewWillDisappear(false)
        cameraController.viewDidDisappear(false)
        XCTAssertFalse(fakeCamera.isStarted, "The camera should be started when the view appears")
    }
    
    func testHasDelegate() {
        cameraController.delegate = self
        XCTAssertNotNil(cameraController.delegate, "CameraViewController should have a delegate")
    }
    
    func testTakingPicture() {
        _ = cameraController.view      // force the view to load
        cameraController.viewWillAppear(false)
        cameraController.viewDidAppear(false)
        cameraController.delegate = self
        cameraController.takePicture()
        XCTAssertTrue(didTakePicture, "Invoking takePicture would ask the Camera to capture a still image")
    }
}

extension CameraViewControllerTests: CameraViewControllerDelegate {
    
    func cameraViewController(controller:CameraViewController, didCaptureImage data:Data) {
        didTakePicture = true
    }
    
    func cameraViewController(controller:CameraViewController, didFailWithError error:Error) {
        
    }
    
}
