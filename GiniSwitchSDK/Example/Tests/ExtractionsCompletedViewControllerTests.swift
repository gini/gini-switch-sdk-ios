//
//  ExtractionsCompletedViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 03.07.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

class ExtractionsCompletedViewControllerTests: XCTestCase {
    
    let storyboard = switchStoryboard()
    var completionViewController:ExtractionsCompletedViewController! = nil
    
    override func setUp() {
        super.setUp()
        completionViewController = storyboard?.instantiateViewController(withIdentifier: "ExtractionsCompletedViewController") as! ExtractionsCompletedViewController
        _ = completionViewController.view
    }
    
    func testInitFromStoryboard() {
        XCTAssertNotNil(completionViewController, "Should be able to init ExtractionsCompletedViewController from the storyboard")
    }
    
    func testHasImageView() {
        XCTAssertNotNil(completionViewController.imageView, "ExtractionsCompletedViewController should have an image view")
    }
    
    func testHasLabel() {
        XCTAssertNotNil(completionViewController.textLabel, "ExtractionsCompletedViewController should have a text label")
    }
    
    func testSetImage() {
        let testImage = UIImage()
        completionViewController.image = testImage
        XCTAssertEqual(completionViewController.imageView.image, testImage, "Setting the image property should result in populating the image view")
    }
    
    func testSetText() {
        let testText = "Extractions Completed"
        completionViewController.text = testText
        XCTAssertEqual(completionViewController.textLabel.text, testText, "Setting the text property should result in populating the text label")
    }
    
}
