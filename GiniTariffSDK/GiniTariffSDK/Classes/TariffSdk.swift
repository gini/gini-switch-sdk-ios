//
//  TariffSdk.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

import UIKit

protocol TariffSdkDelegate: class {
    
    // TODO: make methods optional
    func tariffSdkDidStart(sdk:TariffSdk)
    func tariffSdk(sdk:TariffSdk, didCapture image:UIImage)    // TODO: maybe use NSData?
    func tariffSdk(sdk:TariffSdk, didUpload image:UIImage)    // TODO: maybe use NSData?
    func tariffSdk(sdk:TariffSdk, didReview image:UIImage)    // TODO: maybe use NSData?
    func tariffSdkDidExtractionsComplete(sdk:TariffSdk)
    func tariffSdk(sdk:TariffSdk, didExtractInfo info:NSData)  // TODO: replace info with a real object
    func tariffSdk(sdk:TariffSdk, didReceiveError error:Error)
    func tariffSdk(sdk:TariffSdk, didFailWithError error:Error)
    
}

class TariffSdk {
    
    let clientId: String?
    let clientSecret: String?
    let clientDomain: String?
    
    weak var delegate:TariffSdkDelegate? = nil
    
    init() {
        clientId = ""
        clientSecret = ""
        clientDomain = ""
    }
    
    init(clientId: String, clientSecret: String, domain: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.clientDomain = domain
    }

}
