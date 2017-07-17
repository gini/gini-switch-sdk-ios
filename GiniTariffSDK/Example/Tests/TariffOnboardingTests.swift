//
//  TariffOnboardingTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 28.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class TariffOnboardingTests: XCTestCase {
    
    let testImage = UIImage()
    let testText = "Go onboard yourself"
    
    func testCreatingOnboardingPage() {
        let page = testPage()
        XCTAssertEqual(page.image, testImage, "OnboardingPage needs to have an image property")
        XCTAssertEqual(page.text, testText, "OnboardingPage needs to have a text property")
    }
    
    func testSettingOnboardingPages() {
        let pages = [testPage(), testPage()]
        let onboarding = TariffOnboarding(pages:pages)
        XCTAssertEqual(onboarding.pages, pages, "TariffOnboarding should have a pages array")
    }
    
}

extension TariffOnboardingTests {
    
    func testPage() -> OnboardingPage {
        return OnboardingPage(image: testImage, text: testText)
    }
}
