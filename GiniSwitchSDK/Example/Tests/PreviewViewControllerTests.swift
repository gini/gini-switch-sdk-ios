//
//  PreviewViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 24.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

final class PreviewViewControllerTests: XCTestCase {
    
    let storyboard = switchStoryboard()
    var previewController:PreviewViewController! = nil
    
    var didDeletePage = false
    var didRequestRetake = false
    
    override func setUp() {
        super.setUp()
        previewController = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        _ = previewController.view
        previewController.delegate = self
        didDeletePage = false
        didRequestRetake = false
    }
    
    func testPreviewControllerFromStoryboard() {
        XCTAssertNotNil(previewController, "PreviewViewController should be present in the SDK's storyboard")
    }
    
    func testHasPreviewImageView() {
        XCTAssertNotNil(previewController.pagePreview, "PreviewViewController should have an image view that shows the page")
    }
    
    func testHasTitleTextLabel() {
        XCTAssertNotNil(previewController.titleLabel, "PreviewViewController should have a title text")
    }
    
    func testHasRetakeButton() {
        XCTAssertNotNil(previewController.retakeButton, "PreviewViewController should have a retake button")
    }
    
    func testHasDeleteButton() {
        XCTAssertNotNil(previewController.deleteButton, "PreviewViewController should have a delete button")
    }
    
    func testHasDelegate() {
        XCTAssertTrue(previewController.delegate === self, "PreviewViewController should have a delegate")
    }
    
    func testCanSetPage() {
        let testPage = ScanPage()
        previewController.page = testPage
        XCTAssertEqual(previewController.page, testPage, "Should be able to setup PreviewViewController with a ScanPage")
    }
    
    func testInitWithPage() {
        let testPage = testImageScanPage()
        previewController.page = testPage
        // the actual contents of the image is not verified. For simplicity, it is assumed that if
        // there is an image in the image view, it would be the correct one
        XCTAssertNotNil(previewController.pagePreview.image, "PreviewViewController should display a preview of the page on it's image view")
    }
    
    func testDeletingPage() {
        previewController.page = ScanPage()
        previewController.onDeleteTapped()
        XCTAssertTrue(didDeletePage, "The delegate method for delete page should be called after the delete button is tapped")
    }
    
    func testRetakingPhoto() {
        previewController.page = ScanPage()
        previewController.onRetakeTapped()
        XCTAssertTrue(didRequestRetake, "The delegate method for retaking photo should be called after the retake button is tapped")
    }
    
    func testFailedPage() {
        let testPage = testImageScanPage()
        testPage.status = .failed
        previewController.page = testPage
        XCTAssertEqual(previewController.titleLabel.text, previewController.failedPageTitle, "If the page analysis failed, the screen title needs to reflect that")
    }
    
    func testAnalysedPage() {
        let testPage = testImageScanPage()
        testPage.status = .analysed
        previewController.page = testPage
        XCTAssertEqual(previewController.titleLabel.text, previewController.analysedPageTitle, "If the page analysis failed, the screen title needs to reflect that")
    }
    
}

extension PreviewViewControllerTests: PreviewViewControllerDelegate {
    
    func previewController(previewController:PreviewViewController, didDeletePage page:ScanPage) {
        didDeletePage = true
    }
    
    func previewController(previewController:PreviewViewController, didRequestRetake page:ScanPage) {
        didRequestRetake = true
    }
    
}
