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
        pages = []
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
