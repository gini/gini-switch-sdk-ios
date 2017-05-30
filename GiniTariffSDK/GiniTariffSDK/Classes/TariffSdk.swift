//
//  TariffSdk.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

import UIKit

public protocol TariffSdkDelegate: class {
    
    // TODO: make methods optional
    func tariffSdkDidStart(sdk:TariffSdk)
    func tariffSdk(sdk:TariffSdk, didCapture image:UIImage)    // TODO: maybe use NSData?
    func tariffSdk(sdk:TariffSdk, didUpload image:UIImage)    // TODO: maybe use NSData?
    func tariffSdk(sdk:TariffSdk, didReview image:UIImage)    // TODO: maybe use NSData?
    func tariffSdkDidExtractionsComplete(sdk:TariffSdk)
    func tariffSdk(sdk:TariffSdk, didExtractInfo info:NSData)  // TODO: replace info with a real object
    func tariffSdk(sdk:TariffSdk, didReceiveError error:Error)
    func tariffSdk(sdk:TariffSdk, didFailWithError error:Error)
    func tariffSdkDidCancel(sdk:TariffSdk)
    
}

public class TariffSdk {
    
    public let clientId: String
    public let clientSecret: String
    public let clientDomain: String
    
    public weak var delegate:TariffSdkDelegate? = nil
    
    let userInterface = TariffUserInterface()
    public let configuration = TariffConfiguration()
    
    /*
     * Convenience getter for the appearance object in the configuration
     */
    public var appearance:TariffAppearance {
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
        TariffSdkStorage.activeTariffSdk = self     // TODO: Don't use TariffSdkStorage - find a better solution
    }
    
    public func instantiateTariffViewController() -> UIViewController {
        return userInterface.initialViewController
    }

}
