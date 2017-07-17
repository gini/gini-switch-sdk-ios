//
//  TariffExampleViewController.swift
//  Gini Switch SDK
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
        let sdk = SdkBuilder.customizedTariffSdk()
        sdk.delegate = self
        let tariffController = sdk.instantiateTariffViewController()
        self.present(tariffController, animated: true) { 
            // TODO: maybe show a "thank you" note
        }
    }

}

extension TariffExampleViewController: TariffSdkDelegate {
    
    func tariffSdkDidStart(sdk:TariffSdk) {
        print("Tariff SDK did start")
    }
    
    func tariffSdk(sdk:TariffSdk, didCapture imageData:Data) {
        print("Tariff SDK captured an image")
    }
    
    func tariffSdk(sdk:TariffSdk, didUpload imageData:Data) {
        print("Tariff SDK uploaded an image")
    }
    
    func tariffSdk(sdk:TariffSdk, didReview imageData:Data) {
        print("Tariff SDK reviewed an image")
    }
    
    func tariffSdkDidComplete(sdk:TariffSdk) {
        print("Tariff SDK completed")
        self.dismiss(animated: true, completion: nil)
    }
    
    func tariffSdk(sdk:TariffSdk, didExtractInfo info:ExtractionCollection) {
        print("TariffSDK did receive extractions")
    }
    
    func tariffSdk(sdk:TariffSdk, didReceiveError error:Error) {
        print("Tariff SDK did receive an error: \(error.localizedDescription)")
    }
    
    func tariffSdk(sdk:TariffSdk, didFailWithError error:Error) {
        print("Tariff SDK finished with error: \(error.localizedDescription)")
    }
    
    func tariffSdkDidCancel(sdk:TariffSdk) {
        print("Tariff SDK interrupted")
        self.dismiss(animated: true, completion: nil)
    }
    
}
