//
//  MultiPageCoordinatorTests.swift
//  GiniTariffSDK
//
//  Created by Gini GmbH on 16.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class MultiPageCoordinatorTests: XCTestCase {
    
    var coordinator:MultiPageCoordinator! = nil
    var fakeCamera:FakeCamera! = nil
    
    // delegate state variables
    var didRequestReviewScreen = false
    var didRequestReviewDismiss = false
    var requestedReviewScreen:ReviewViewController? = nil
    var requestedExtractionScreen:ExtractionsViewController? = nil
    var exitActionSheet:UIAlertController? = nil
    
    override func setUp() {
        super.setUp()
        let cameraController = CameraViewController()
        fakeCamera = try! FakeCamera()
        fakeCamera.hardCodedImageData = testImageData()
        cameraController.camera = fakeCamera
        coordinator = MultiPageCoordinator(camera: cameraController, cameraOptions: CameraOptionsViewController(), pagesCollection: PagesCollectionViewController())
        coordinator.delegate = self
        didRequestReviewScreen = false
        didRequestReviewDismiss = false
        requestedReviewScreen = nil
        requestedExtractionScreen = nil
        exitActionSheet = nil
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
    
    func testHasDelegate() {
        coordinator.delegate = self
        XCTAssertNotNil(coordinator.delegate, "MultiPageCoordinator should have a delegate")
    }
    
    func testTakingPictureAfterCaptureButtonIsTapped() {
        coordinator.cameraOptionsController.onCaptureTapped()
        XCTAssertTrue(fakeCamera.hasCaptured, "If the capture button on the camera options controller is tapped, MultiPageCoordinator should route that to the camera object")
    }
    
    func testGoingToReviewAfterCapture() {
        coordinator.cameraController.takePicture()
        XCTAssertTrue(didRequestReviewScreen, "The multiPageCoordinator:requestedShowingController should be invoked in order for the review screen to be presented")
    }
    
    func testReviewControllerDismiss() {
        coordinator.cameraController.takePicture()
        requestedReviewScreen?.rejectButtonTapped()
        XCTAssertTrue(didRequestReviewDismiss, "After the image is rejected, the review screen should be dismissed")
    }
    
    func testGoingToExtractions() {
        coordinator.cameraOptionsController.onDoneTapped()
        XCTAssertNotNil(requestedExtractionScreen, "Tapping on the done button should result in the extractions being shown")
    }
    
    func testExitSDKActionsSheet() {
        coordinator.pageCollectionController.onOptionsTapped()
        XCTAssertNotNil(exitActionSheet, "Tapping on the options button should result in an action sheet confirming exiting being shown")
    }
}

extension MultiPageCoordinatorTests: MultiPageCoordinatorDelegate {
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedShowingController:UIViewController, presentationStyle:PresentationStyle, animated:Bool, completion:(() -> Void)?) {
        didRequestReviewScreen = true
        requestedReviewScreen = requestedShowingController as? ReviewViewController
        requestedExtractionScreen = requestedShowingController as? ExtractionsViewController
        exitActionSheet = requestedShowingController as? UIAlertController
    }
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedDismissingController:UIViewController, presentationStyle:PresentationStyle, animated:Bool) {
        didRequestReviewDismiss = true
    }
    
}
