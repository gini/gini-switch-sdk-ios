//
//  OnboardingPageViewControllerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 28.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class OnboardingPageViewControllerTests: XCTestCase {
    
    var onboadingPage:OnboardingPageViewController! = nil
    let storyboard = switchStoryboard()
    
    override func setUp() {
        super.setUp()
        onboadingPage = storyboard?.instantiateViewController(withIdentifier: "OnboardingPageViewController") as! OnboardingPageViewController
        _ = onboadingPage.view
    }
    
    func testInitFromStoryboard() {
        XCTAssertNotNil(onboadingPage, "OnboardingPageViewController should be present in the Tariff storyboard")
    }
    
    func testOnboardingImage() {
        let testImage = UIImage()
        onboadingPage.image = testImage
        XCTAssertEqual(onboadingPage.image, testImage, "OnboardingPageViewController needs to have an image property")
    }
    
    func testDisplayingImage() {
        let testImage = UIImage()
        onboadingPage.image = testImage
        XCTAssertEqual(onboadingPage.imageView?.image, testImage, "OnboardingPageViewController should display the supplied image in the image view")
    }
    
    func testOnboardingText() {
        let testText = "Onboarding 1"
        onboadingPage.text = testText
        XCTAssertEqual(onboadingPage.text, testText, "OnboardingPageViewController needs to have a text property")
    }
    
    func testDisplayingText() {
        let testText = "Onboarding 1"
        onboadingPage.text = testText
        XCTAssertEqual(onboadingPage.textLabel?.text, testText, "OnboardingPageViewController should display the supplied text in the label")
    }
    
}
