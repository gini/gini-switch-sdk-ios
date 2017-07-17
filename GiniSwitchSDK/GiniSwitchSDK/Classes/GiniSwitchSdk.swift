//
//  TariffSdk.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

import UIKit

public protocol GiniSwitchSdkDelegate: class {
    
    // TODO: make methods optional
    func tariffSdkDidStart(sdk:GiniSwitchSdk)
    func tariffSdk(sdk:GiniSwitchSdk, didCapture imageData:Data)
    func tariffSdk(sdk:GiniSwitchSdk, didUpload imageData:Data)
    func tariffSdk(sdk:GiniSwitchSdk, didReview imageData:Data)
    func tariffSdkDidComplete(sdk:GiniSwitchSdk)
    func tariffSdk(sdk:GiniSwitchSdk, didExtractInfo info:ExtractionCollection)
    func tariffSdk(sdk:GiniSwitchSdk, didReceiveError error:Error)
    func tariffSdk(sdk:GiniSwitchSdk, didFailWithError error:Error)
    func tariffSdkDidCancel(sdk:GiniSwitchSdk)
    
}

public class GiniSwitchSdk {
    
    public let clientId: String
    public let clientSecret: String
    public let clientDomain: String
    
    public weak var delegate:GiniSwitchSdkDelegate? = nil
    
    let userInterface = GiniSwitchUserInterface()
    public var configuration = GiniSwitchConfiguration()
    
    /*
     * Convenience getter for the appearance object in the configuration
     */
    public var appearance:GiniSwitchAppearance {
        return configuration.appearance
    }
    
    public init() {
        clientId = ""
        clientSecret = ""
        clientDomain = ""
    }
    
    public init(clientId: String, clientSecret: String, domain: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.clientDomain = domain
        GiniSwitchSdkStorage.activeSwitchSdk = self     // TODO: Don't use TariffSdkStorage - find a better solution
    }
    
    public func instantiateTariffViewController() -> UIViewController {
        return userInterface.initialViewController
    }

}
