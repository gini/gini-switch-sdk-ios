//
//  TariffOnboardingTests.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 28.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GiniTariffSDK

class TariffOnboardingTests: XCTestCase {
    
    let testImage = UIImage()
    let testText = "Go onboard yourself"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
