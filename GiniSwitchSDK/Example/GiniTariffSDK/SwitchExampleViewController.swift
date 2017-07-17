//
//  SwitchExampleViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 05/05/2017.
//  Copyright (c) 2017 Gini GmbH. All rights reserved.
//

import UIKit
import GiniTariffSDK

class SwitchExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStartSdk() {
        let sdk = SdkBuilder.customizedTariffSdk()
        sdk.delegate = self
        let tariffController = sdk.instantiateTariffViewController()
        self.present(tariffController, animated: true) { 
            // TODO: maybe show a "thank you" note
        }
    }

}

extension SwitchExampleViewController: GiniSwitchSdkDelegate {
    
    func tariffSdkDidStart(sdk:GiniSwitchSdk) {
        print("Tariff SDK did start")
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didCapture imageData:Data) {
        print("Tariff SDK captured an image")
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didUpload imageData:Data) {
        print("Tariff SDK uploaded an image")
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didReview imageData:Data) {
        print("Tariff SDK reviewed an image")
    }
    
    func tariffSdkDidComplete(sdk:GiniSwitchSdk) {
        print("Tariff SDK completed")
        self.dismiss(animated: true, completion: nil)
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didExtractInfo info:ExtractionCollection) {
        print("TariffSDK did receive extractions")
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didReceiveError error:Error) {
        print("Tariff SDK did receive an error: \(error.localizedDescription)")
    }
    
    func tariffSdk(sdk:GiniSwitchSdk, didFailWithError error:Error) {
        print("Tariff SDK finished with error: \(error.localizedDescription)")
    }
    
    func tariffSdkDidCancel(sdk:GiniSwitchSdk) {
        print("Tariff SDK interrupted")
        self.dismiss(animated: true, completion: nil)
    }
    
}
