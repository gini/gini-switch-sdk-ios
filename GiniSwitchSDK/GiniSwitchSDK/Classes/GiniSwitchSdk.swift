//
//  GiniSwitchSdk.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

import UIKit

public protocol GiniSwitchSdkDelegate: class {
    
    // TODO: make methods optional
    func switchSdkDidStart(sdk:GiniSwitchSdk)
    func switchSdk(sdk:GiniSwitchSdk, didCapture imageData:Data)
    func switchSdk(sdk:GiniSwitchSdk, didUpload imageData:Data)
    func switchSdk(sdk:GiniSwitchSdk, didReview imageData:Data)
    func switchSdkDidComplete(sdk:GiniSwitchSdk)
    func switchSdk(sdk:GiniSwitchSdk, didExtractInfo info:ExtractionCollection)
    func switchSdk(sdk:GiniSwitchSdk, didReceiveError error:Error)
    func switchSdk(sdk:GiniSwitchSdk, didFailWithError error:Error)
    func switchSdkDidCancel(sdk:GiniSwitchSdk)
    
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
        GiniSwitchSdkStorage.activeSwitchSdk = self     // TODO: Don't use GiniSwitchSdkStorage - find a better solution
    }
    
    public func instantiateSwitchViewController() -> UIViewController {
        return userInterface.initialViewController
    }

}
