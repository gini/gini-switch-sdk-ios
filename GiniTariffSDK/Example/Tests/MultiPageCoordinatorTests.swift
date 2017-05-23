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
    
    func testAddingPageAfterCapture() {
        coordinator.cameraController.takePicture()
        XCTAssertEqual(coordinator.pageCollectionController.pages?.count, 1, "After taking the picture, the pages collection controller should have one page")
    }
    
    func testGoingToReviewAfterCapture() {
        coordinator.cameraController.takePicture()
        XCTAssertTrue(didRequestReviewScreen, "The multiPageCoordinator:requestedShowingController should be invoked in order for the review screen to be presented")
    }
    
    func testReviewScreenPage() {
        coordinator.cameraController.takePicture()
        XCTAssertEqual(coordinator.pageCollectionController.pages?.last, requestedReviewScreen?.page, "The page under review, should be the last one in the collection")
    }
    
    func testReviewControllerDismiss() {
        coordinator.cameraController.takePicture()
        requestedReviewScreen?.rejectButtonTapped()
        XCTAssertTrue(didRequestReviewDismiss, "After the image is rejected, the review screen should be dismissed")
    }
    
    func testRejectingPicture() {
        coordinator.cameraController.takePicture()
        let pagesNum = coordinator.pageCollectionController.pages?.count
        requestedReviewScreen?.rejectButtonTapped()
        let pagesNumAfterReject = coordinator.pageCollectionController.pages?.count
        XCTAssertEqual(pagesNum! - 1, pagesNumAfterReject, "If an image is rejected, it has to be removed from the list")
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
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedShowingController:UIViewController, presentationStyle:PresentationStyle) {
        didRequestReviewScreen = true
        requestedReviewScreen = requestedShowingController as? ReviewViewController
        requestedExtractionScreen = requestedShowingController as? ExtractionsViewController
        exitActionSheet = requestedShowingController as? UIAlertController
    }
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedDismissingController:UIViewController, presentationStyle:PresentationStyle) {
        didRequestReviewDismiss = true
    }
    
}
