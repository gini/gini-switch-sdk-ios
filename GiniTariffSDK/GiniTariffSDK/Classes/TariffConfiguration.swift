//
//  TariffConfiguration.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

import UIKit

struct TariffConfiguration {
    
    // Appearance
    let appearance = TariffAppearance()
    
    // Logging
    var logging = TariffConsoleLogger()
    
    // Analytics
    var analytics = TariffNopAnalytics()
    
    // Onboarding
    let onboarding = TariffOnboarding()
    
}
