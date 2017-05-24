//
//  ViewController.swift
//  GiniTariffSDK
//
//  Created by Gini GmbH on 05/05/2017.
//  Copyright (c) 2017 Gini GmbH. All rights reserved.
//

import UIKit
import GiniTariffSDK

class TariffExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStartSdk() {
        let sdk = TariffSdk(clientId: "TestId", clientSecret: "secret", domain: "gini.net")
        sdk.delegate = self
        let tariffController = sdk.instantiateTariffViewController()
        self.present(tariffController, animated: true) { 
            // TODO: maybe show a "thank you" note
        }
    }

}

extension TariffExampleViewController: TariffSdkDelegate {
    
    func tariffSdkDidStart(sdk:TariffSdk) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didCapture image:UIImage) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didUpload image:UIImage) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didReview image:UIImage) {
        
    }
    
    func tariffSdkDidExtractionsComplete(sdk:TariffSdk) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tariffSdk(sdk:TariffSdk, didExtractInfo info:NSData) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didReceiveError error:Error) {
        
    }
    
    func tariffSdk(sdk:TariffSdk, didFailWithError error:Error) {
        
    }
    
    func tariffSdkDidCancel(sdk:TariffSdk) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
