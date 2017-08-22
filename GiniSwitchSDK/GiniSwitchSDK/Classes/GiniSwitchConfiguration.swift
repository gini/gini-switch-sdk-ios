//
//  GiniSwitchConfiguration.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

import UIKit

public struct GiniSwitchConfiguration {
    
    /*
     * Logging is the object the Switch SDK will be using to write diagnostics information.
     * By default, GiniSwitchConsoleLogger will be used - it will just write to the standard output
     * and also have a basic support for log levels. Clients are free to replace that with their
     * own implementation using the TariffLogger protocol.
     */
    public var logging:GiniSwitchLogger {
        get {
            return logger
        }
        set {
            logger = newValue
        }
    }
    
    /*
     * By default, the Switch SDK doesn't send analytics events. You can change that by implementing
     * the GiniSwitchAnalytics protocol and replacing the analytics property here.
     */
    var analytics:GiniSwitchAnalytics = GiniSwitchNopAnalytics()
    
    /*
     * During the SDK's first run, an onboarding sequence will be shown. While a default content is
     * provided, clients can override that and use their own data using a GiniSwitchOnboarding object
     */
    public var onboarding = GiniSwitchOnboarding()
    
}
