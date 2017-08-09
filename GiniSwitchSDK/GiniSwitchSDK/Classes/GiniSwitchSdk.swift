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
    func switchSdkDidCancel(sdk:GiniSwitchSdk)
    func switchSdkDidSendFeedback(sdk:GiniSwitchSdk)
    
}

public class GiniSwitchSdk {
    
    /// The client ID you got from Gini GmbH
    public let clientId: String
    /// The client secret, securing your account, provided by Gini GmbH
    public let clientSecret: String
    /// Your domain. Will be used when creating new users
    public let clientDomain: String
    
    /// The delegate object, receiving callbacks about events happening in the SDK
    public weak var delegate:GiniSwitchSdkDelegate? = nil
    
    /// The object responsible for creating the SDK's UI
    let userInterface = GiniSwitchUserInterface()
    /// Contains some configuration objects that can be used to customize the SDK
    public var configuration = GiniSwitchConfiguration()
    
    /*
     * Convenience getter for the appearance object in the configuration
     */
    public var appearance:GiniSwitchAppearance {
        return configuration.appearance
    }
    
    /*
     * Creates a GiniSwitchSdk instance based on the provided credentials
     */
    public init(clientId: String = "", clientSecret: String = "", domain: String = "") {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.clientDomain = domain
        GiniSwitchSdkStorage.activeSwitchSdk = self     // TODO: Don't use GiniSwitchSdkStorage - find a better solution
    }
    
    /*
     * Convenience method for creating the SDK's UI
     */
    public func instantiateSwitchViewController() -> UIViewController {
        return userInterface.initialViewController
    }
    
    /*
     * Disposes of the current SDK object. Should be called after clients are done with the SDK
     * in order to clean up
     */
    public func terminate() {
        GiniSwitchSdkStorage.activeSwitchSdk = nil     // TODO: Don't use GiniSwitchSdkStorage - find a better solution
    }

}
