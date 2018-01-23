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
    
    static let clientIDKey = "ClientID";
    static let clientSecretKey = "ClientSecret";
    static let clientDomainKey = "ClientDomain";

    static func customizedSwitchSdk() -> GiniSwitchSdk {
        let credentials = self.clientCredentials()
        let sdk = GiniSwitchSdk(clientId: credentials.clientId,
                                clientSecret: credentials.clientSecret,
                                domain: credentials.clientDomain)
        
        // Change the main colors
        GiniSwitchAppearance.positiveColor = UIColor(red: 32.0 / 255.0, green: 186.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
        GiniSwitchAppearance.negativeColor = UIColor(red: 204.0 / 255.0, green: 33.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        GiniSwitchAppearance.screenBackgroundColor = UIColor.black
        
        // change the exit action sheet text
        GiniSwitchAppearance.exitActionSheetTitle = NSLocalizedString("Foto-Modus verlassen?", comment: "Leave SDK actionsheet title")
        
        // Use the following template to add your own onboarding pages
        // let onboarding1 = OnboardingPage(image:UIImage(named:"onboardingPage1", in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"), compatibleWith: nil)!, text: "1")
        // let onboarding2 = OnboardingPage(image:UIImage(named:"onboardingPage2", in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"), compatibleWith: nil)!, text: "2")
        // let onboarding3 = OnboardingPage(image:UIImage(named:"onboardingPage3", in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"), compatibleWith: nil)!, text: "3")
        // sdk.configuration.onboarding = GiniSwitchOnboarding(pages: [onboarding1, onboarding2, onboarding3])
        
        return sdk
    }
    
    static func clientCredentials() -> (clientId:String, clientSecret:String, clientDomain:String) {
        if let path = Bundle.main.path(forResource: "Credentials", ofType: "plist"),
            let keys = NSDictionary(contentsOfFile: path),
            let clientId = keys[self.clientIDKey] as? String,
            let clientSecret = keys[self.clientSecretKey] as? String,
            let clientDomain = keys[self.clientDomainKey] as? String {
            return (clientId, clientSecret, clientDomain)
        }
        else {
            return ("", "", "")
        }
    }
}
