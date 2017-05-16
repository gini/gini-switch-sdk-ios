//
//  MultiPageCoordinatorTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 16.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class MultiPageCoordinatorTests: XCTestCase {
    
    var coordinator:MultiPageCoordinator! = nil
    var fakeCamera:FakeCamera! = nil
    
    override func setUp() {
        super.setUp()
        let cameraController = CameraViewController()
        fakeCamera = try! FakeCamera()
        fakeCamera.hardCodedImageData = testImageData()
        cameraController.camera = fakeCamera
        coordinator = MultiPageCoordinator(camera: cameraController, cameraOptions: CameraOptionsViewController(), pagesCollection: PagesCollectionViewController())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHasCameraOptionsController() {
        XCTAssertNotNil(coordinator.cameraOptionsController, "MultiPageCoordinator should have a reference to the camera options controller")
    }
    
    func testHasCameraController() {
        XCTAssertNotNil(coordinator.cameraController, "MultiPageCoordinator should have a reference to the camera controller")
    }
    
    func testHasPageCollectionController() {
        XCTAssertNotNil(coordinator.pageCollectionController, "MultiPageCoordinator should have a reference to the page collection controller")
    }
    
    func testTakingPictureAfterCaptureButtonIsTapped() {
        coordinator.cameraOptionsController.onCaptureTapped()
        XCTAssertTrue(fakeCamera.hasCaptured, "If the capture button on the camera options controller is tapped, MultiPageCoordinator should route that to the camera object")
    }
    
    func testAddingPageAfterCapture() {
        coordinator.cameraController.takePicture()
        XCTAssertEqual(coordinator.pageCollectionController.pages?.count, 1, "After taking the picture, the pages collection controller should have one page")
    }
    
}
