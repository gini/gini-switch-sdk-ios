//
//  MultiPageCoordinatorTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 16.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class MultiPageCoordinatorTests: XCTestCase {
    
    var coordinator:MultiPageCoordinator! = nil
    var fakeCamera:FakeCamera! = nil
    
    // delegate state variables
    var didRequestReviewScreen = false
    var didRequestReviewDismiss = false
    var requestedReviewScreen:ReviewViewController? = nil
    var exitActionSheet:UIAlertController? = nil
    
    override func setUp() {
        super.setUp()
        let cameraController = CameraViewController()
        fakeCamera = try! FakeCamera()
        fakeCamera.hardCodedImageData = testImageData()
        cameraController.camera = fakeCamera
        coordinator = MultiPageCoordinator(extractionsManager:ExtractionsManager(), onboarding:GiniSwitchOnboarding())
        didRequestReviewScreen = false
        didRequestReviewDismiss = false
        requestedReviewScreen = nil
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
        XCTAssertNil(coordinator.delegate, "MultiPageCoordinator should have a delegate")
    }
    
    func testDefaultPresentationStyles() {
        XCTAssertEqual(coordinator.presentationStyle, .modal, " Switch User Interface should have a presentation style, defaulting to .modal")
    }
    
    func testCanChangePresentationStlye() {
        coordinator.presentationStyle = .navigation
        XCTAssertEqual(coordinator.presentationStyle, .navigation, "Should be able to change MultiPageCoordinator's presentation style")
    }
    
    func testCreatingInitialViewController() {
        let viewController = coordinator.initialViewController as UIViewController
        XCTAssertNotNil(viewController, "SwitchUI should return a UIViewController instance")
    }
    
    func testViewControllerForModalPresentation() {
        // if the presentation style is modal, the view controller will have to be embedded in a
        // navigation stack
        coordinator.presentationStyle = .modal
        let viewController = coordinator.initialViewController as? UINavigationController
        XCTAssertNotNil(viewController, "SwitchUI with modal presentation style should return a UINavigationController instance")
    }
    
    func testViewControllerForNavigationPresentation() {
        // if the presentation style is modal, the view controller will have to be embedded in a
        // navigation stack
        coordinator.presentationStyle = .navigation
        let viewController = coordinator.initialViewController as? UINavigationController
        XCTAssertNil(viewController, "SwitchUI with navigaiton presentation style should not be embedded in a navigation stack")
    }
    
    func testReturnsMultiPageScanController() {
        coordinator.presentationStyle = .navigation    // otherwise it would be embedded into a navigation controller
        let viewController = coordinator.initialViewController as? MultiPageScanViewController
        XCTAssertNotNil(viewController, "SwitchUI should return a MultiPageScanViewController instance")
    }
    
    // TODO: after the GiniSwitchSdk refactoring, these tests are no longer valid, but it would be nice to re-write them
    // so that these interactions can be tested
//    func testTakingPictureAfterCaptureButtonIsTapped() {
//        coordinator.cameraOptionsController.onCaptureTapped()
//        XCTAssertTrue(fakeCamera.hasCaptured, "If the capture button on the camera options controller is tapped, MultiPageCoordinator should route that to the camera object")
//    }
//    
//    func testGoingToReviewAfterCapture() {
//        coordinator.cameraController.takePicture()
//        XCTAssertTrue(didRequestReviewScreen, "The multiPageCoordinator:requestedShowingController should be invoked in order for the review screen to be presented")
//    }
//    
//    func testReviewControllerDismiss() {
//        coordinator.cameraController.takePicture()
//        requestedReviewScreen?.rejectButtonTapped()
//        XCTAssertTrue(didRequestReviewDismiss, "After the image is rejected, the review screen should be dismissed")
//    }
//    
//    func testExitSDKActionsSheet() {
//        coordinator.pageCollectionController.onOptionsTapped()
//        XCTAssertNotNil(exitActionSheet, "Tapping on the options button should result in an action sheet confirming exiting being shown")
//    }
}
