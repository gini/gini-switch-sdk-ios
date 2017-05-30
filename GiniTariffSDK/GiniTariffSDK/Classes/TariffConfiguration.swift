//
//  TariffConfiguration.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

import UIKit

public struct TariffConfiguration {
    
    /*
     * TariffAppearance can be used to change some visual components of the SDK like
     * images, text and colors.
     * @note Alongside TariffAppearance, you can also use UIAppearance to apply your own theme
     * to the Tariff SDK
     */
    let appearance = TariffAppearance()
    
    /*
     * Logging is the object the Tariff SDK will be using to write diagnostics information.
     * By default, TariffConsoleLogger will be used - it will just write to the standard output
     * and also have a basic support for log levels. Clients are free to replace that with their
     * own implementation using the TariffLogger protocol.
     */
    public var logging:TariffLogger = TariffConsoleLogger()
    
    /*
     * By default, the Tariff SDK doesn't send analytics events. You can change that by implementing
     * the TariffAnalytics protocol and replacing the analytics property here.
     */
    var analytics:TariffAnalytics = TariffNopAnalytics()
    
    /*
     * During the SDK's first run, an onboarding sequence will be shown. While a default content is
     * provided, clients can override that and use their own data using a TariffOnboarding object
     */
    public let onboarding = TariffOnboarding()
    
}
