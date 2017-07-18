//
//  SdkBuilder.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 06.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import UIKit
import GiniSwitchSDK

struct SdkBuilder {

    static func customizedSwitchSdk() -> GiniSwitchSdk {
        let sdk = GiniSwitchSdk(clientId: "TestId", clientSecret: "secret", domain: "gini.net")
        
        // Change the main colors
        sdk.appearance.positiveColor = UIColor(colorLiteralRed: 32.0 / 255.0, green: 186.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
        sdk.appearance.negativeColor = UIColor(colorLiteralRed: 204.0 / 255.0, green: 33.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        sdk.appearance.screenBackgroundColor = UIColor.black
        
        // change the exit action sheet text
        sdk.appearance.exitActionSheetTitle = NSLocalizedString("Gini Switch verlassen?", comment: "Leave SDK actionsheet title")
        
        // Use the following template to add your own onboarding pages
        // let onboarding1 = OnboardingPage(image:UIImage(named:"onboardingPage1", in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"), compatibleWith: nil)!, text: "1")
        // let onboarding2 = OnboardingPage(image:UIImage(named:"onboardingPage2", in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"), compatibleWith: nil)!, text: "2")
        // let onboarding3 = OnboardingPage(image:UIImage(named:"onboardingPage3", in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"), compatibleWith: nil)!, text: "3")
        // sdk.configuration.onboarding = GiniSwitchOnboarding(pages: [onboarding1, onboarding2, onboarding3])
        
        return sdk
    }
}
