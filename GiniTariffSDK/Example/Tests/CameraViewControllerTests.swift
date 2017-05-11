//
//  CameraViewControllerTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 09.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class CameraViewControllerTests: XCTestCase {
  
    let storyboard = tariffStoryboard()
    var cameraController:CameraViewController? = nil
    var fakeCamera:FakeCamera! = nil
    
    override func setUp() {
        super.setUp()
        cameraController = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController
        fakeCamera = try! FakeCamera()
        cameraController?.camera = fakeCamera
    }
    
    func testInitializingCameraFromStoryboard() {
        XCTAssertNotNil(cameraController, "Should be able to initialize CameraViewController from the storyboard")
    }
    
    func testCameraViewControllerHasPreviewView() {
        _ = cameraController?.view      // force the view to load
        let preview:CameraPreviewView? = cameraController?.cameraPreview
        XCTAssertNotNil(preview, "CameraViewController should have a preview property")
    }
    
    func testCameraViewControllerHasCamera() {
        _ = cameraController?.view      // force the view to load
        XCTAssertNotNil(cameraController?.camera, "CameraViewController should have a camera property")
    }
    
    func testPreviewHasCameraSession() {
        _ = cameraController?.view      // force the view to load
        XCTAssertEqual(cameraController?.cameraPreview.session, cameraController?.camera.session, "The Preview view should have the camera session set")
    }
    
    func testCameraWasStartedWhenViewAppeared() {
        _ = cameraController?.view      // force the view to load
        cameraController?.viewWillAppear(false)
        cameraController?.viewDidAppear(false)
        XCTAssertTrue(fakeCamera.isStarted, "The camera should be started when the view appears")
    }
    
    func testCameraWasStoppedWhenViewDisappeared() {
        _ = cameraController?.view      // force the view to load
        cameraController?.viewWillAppear(false)
        cameraController?.viewDidAppear(false)
        cameraController?.viewWillDisappear(false)
        cameraController?.viewDidDisappear(false)
        XCTAssertFalse(fakeCamera.isStarted, "The camera should be started when the view appears")
    }
}
