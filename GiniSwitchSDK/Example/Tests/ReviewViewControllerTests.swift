//
//  ReviewViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 17.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class ReviewViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard.switchStoryboard()
    var reviewController:ReviewViewController! = nil
    let testPage = testImageScanPage()
    
    // delegate state variables
    var didAcceptPicture = false
    var didRejectPicture = false
    var acceptedPage:ScanPage? = nil    // will hold the page return via the delegate methods
    
    override func setUp() {
        super.setUp()
        reviewController = storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        _ = reviewController.view   // force the view to load
        reviewController.page = testPage
        reviewController.delegate = self
        didAcceptPicture = false
        didRejectPicture = false
    }
    
    func testCreatingReviewControllerFromStoryboard() {
        XCTAssertNotNil(reviewController, "ReviewViewController should be present in the Switch storyboard")
    }
    
    func testReviewControllerHasUseButton() {
        XCTAssertNotNil(reviewController.useButton, "ReviewViewController should have a button for confirming the image")
    }
    
    func testReviewControllerHasRetakeButton() {
        XCTAssertNotNil(reviewController.retakeButton, "ReviewViewController should have a button for retaking the image")
    }
    
    func testReviewControllerHasRotateButton() {
        XCTAssertNotNil(reviewController.rotateButton, "ReviewViewController should have a button for rotating the image")
    }
    
    func testReviewControllerHasMoreButton() {
        XCTAssertNotNil(reviewController.moreButton, "ReviewViewController should have a button for more options")
    }
    
    func testReviewControllerHasHintLabel() {
        XCTAssertNotNil(reviewController.hintLabel, "ReviewViewController should have text prompting users to check the image quality")
    }
    
    func testReviewControllerHasPreview() {
        XCTAssertNotNil(reviewController.previewImageView, "ReviewViewController should preview the taken image")
    }
    
    func testCanSetPreview() {
        XCTAssertEqual(reviewController.page, testPage, "ReviewViewController should use a ScanPage object to initialize itself")
    }
    
    func testSettingPagePopulatesThePreviewView() {
        // For simplicity, we will assume that the image set is the current one
        XCTAssertNotNil(reviewController.previewImageView.image, "Setting the page on a ReviewViewController should also set the preview image view's contents")
    }
    
    func testReviewControllerHasDelegate() {
        XCTAssertNotNil(reviewController.delegate, "ReviewViewController should have a delegate")
    }
    
    func testConfirmingPicture() {
        reviewController.useButtonTapped()
        XCTAssertTrue(didAcceptPicture, "Tapping on the useButton should result in the reviewController:didAcceptPage: method being called")
        XCTAssertEqual(acceptedPage, testPage, "The returned page should be the same one input into ReviewViewController")
    }
    
    func testRejectingPicture() {
        reviewController.rejectButtonTapped()
        XCTAssertTrue(didRejectPicture, "Tapping on the rejectButton should result in the reviewController:didRejectPage: method being called")
    }
    
    func testRotateButtonIsRound() {
        XCTAssertEqual(reviewController.rotateButton.layer.cornerRadius, reviewController.rotateButton.frame.width / 2.0, "The rotate button should be round")
    }

}

extension ReviewViewControllerTests: ReviewViewControllerDelegate {
    
    func reviewController(_ controller:ReviewViewController, didAcceptPage page:ScanPage) {
        didAcceptPicture = true
        acceptedPage = page
    }
    
    func reviewController(_ controller:ReviewViewController, didRejectPage page:ScanPage) {
        didRejectPicture = true
    }
    
}
