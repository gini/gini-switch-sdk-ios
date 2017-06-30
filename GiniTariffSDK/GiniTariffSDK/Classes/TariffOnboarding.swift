//
//  TariffOnboarding.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

import UIKit

public struct OnboardingPage {
    
    let image:UIImage
    let text:String
    
    public init() {
        self.init(image:UIImage(), text: "")
    }
    
    public init(image:UIImage, text:String) {
        self.image = image
        self.text = text
    }
}

public struct TariffOnboarding {
    
    let pages:[OnboardingPage]
    
    public init() {
        // init with default pages
        let onboarding1 = OnboardingPage(image:UIImage(named:"onboardingPage1", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)!,
                                         text: NSLocalizedString("Dokument\nflach\nfotografieren", comment: "Onboarding page one text"))
        let onboarding2 = OnboardingPage(image:UIImage(named:"onboardingPage2", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)!,
                                         text: NSLocalizedString("Handy parallel\nzum Dokument\nhalten", comment: "Onboarding page two text"))
        let onboarding3 = OnboardingPage(image:UIImage(named:"onboardingPage3", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)!,
                                         text: NSLocalizedString("Dokument\nvollständig in\nRahmen einpassen", comment: "Onboarding page three text"))
        self.init(pages: [onboarding1, onboarding2, onboarding3])
    }
    
    public init(pages:[OnboardingPage]) {
        self.pages = pages
    }
    
}

extension TariffOnboarding {
    
    static var userDefaults:UserDefaults {
        return UserDefaults.standard
    }
    
    static var onboardingShownKey:String {
        return "HasShownOnboardingKey"
    }
    
    static var hasShownOnboarding: Bool {
        set {
            userDefaults.set(newValue, forKey: onboardingShownKey)
        }
        get {
            return (userDefaults.value(forKey: onboardingShownKey) as? Bool) ?? false
        }
    }
}


extension OnboardingPage: Equatable {
    
    public static func ==(lhs: OnboardingPage, rhs: OnboardingPage) -> Bool {
        return lhs.image == rhs.image && lhs.text == rhs.text
    }
    
}
