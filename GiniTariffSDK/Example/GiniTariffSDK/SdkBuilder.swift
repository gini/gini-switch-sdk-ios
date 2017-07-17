//
//  SdkBuilder.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 06.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import UIKit
import GiniTariffSDK

struct SdkBuilder {

    static func customizedTariffSdk() -> TariffSdk {
        let sdk = TariffSdk(clientId: "TestId", clientSecret: "secret", domain: "gini.net")
        
        // Change the main colors
        sdk.appearance.positiveColor = UIColor(colorLiteralRed: 32.0 / 255.0, green: 186.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
        sdk.appearance.negativeColor = UIColor(colorLiteralRed: 204.0 / 255.0, green: 33.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        sdk.appearance.screenBackgroundColor = UIColor.black
        
        // change the exit action sheet text
        sdk.appearance.exitActionSheetTitle = NSLocalizedString("Leave Gini Switch verlassen?", comment: "Leave SDK actionsheet title")
        
        // change the text of the extractions screen button
        sdk.appearance.extractionsButtonText = NSLocalizedString("Complete the process!", comment: "Extraction screen switch provider title")
        
        // change the colors of the extractions screen
        sdk.appearance.extractionTitleTextColor = UIColor.lightGray
        sdk.appearance.extractionsScreenTitleText = NSLocalizedString("We have extractions!", comment: "Extraction screen title")
        sdk.appearance.extractionsTextFieldTextColor = UIColor.gray
        sdk.appearance.extractionsTextFieldBackgroundColor = UIColor.lightGray
        
        // Use the following template to add your own onboarding pages
        // let onboarding1 = OnboardingPage(image:UIImage(named:"onboardingPage1", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)!, text: "1")
        // let onboarding2 = OnboardingPage(image:UIImage(named:"onboardingPage2", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)!, text: "2")
        // let onboarding3 = OnboardingPage(image:UIImage(named:"onboardingPage3", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)!, text: "3")
        // sdk.configuration.onboarding = TariffOnboarding(pages: [onboarding1, onboarding2, onboarding3])
        
        return sdk
    }
}
