//
//  SwitchExampleViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 05/05/2017.
//  Copyright (c) 2017 Gini GmbH. All rights reserved.
//

import UIKit
import GiniSwitchSDK

class SwitchExampleViewController: UIViewController {
    
    var extractions = ExtractionCollection()
    var switchController:UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStartSdk() {
        let sdk = SdkBuilder.customizedSwitchSdk()
        sdk.delegate = self
        switchController = sdk.instantiateSwitchViewController()
        self.present(switchController!, animated: true, completion: nil)
    }
    
    fileprivate func createExtractionsScreen(extractions:ExtractionCollection) -> ExtractionsViewController {
        let extractionsController = storyboard?.instantiateViewController(withIdentifier: "ExtractionsViewController") as! ExtractionsViewController
        extractionsController.extractionsCollection = extractions
        extractionsController.delegate = self
        return extractionsController
    }
    
    fileprivate func showExtractions(extractions:ExtractionCollection) {
        navigationController?.pushViewController(createExtractionsScreen(extractions: extractions), animated: false)
    }

}

extension SwitchExampleViewController: GiniSwitchSdkDelegate {
    
    func switchSdkDidStart(sdk:GiniSwitchSdk) {
        print("Switch SDK did start")
    }
    
    func switchSdk(sdk:GiniSwitchSdk, didCapture imageData:Data) {
        print("Switch SDK captured an image")
    }
    
    func switchSdk(sdk:GiniSwitchSdk, didUpload imageData:Data) {
        print("Switch SDK uploaded an image")
    }
    
    func switchSdk(sdk:GiniSwitchSdk, didReview imageData:Data) {
        print("Switch SDK reviewed an image")
    }
    
    func switchSdkDidComplete(sdk:GiniSwitchSdk) {
        print("Switch SDK completed")
        self.showExtractions(extractions: self.extractions)
        self.dismiss(animated: true, completion: nil)
    }
    
    func switchSdk(sdk:GiniSwitchSdk, didExtractInfo info:ExtractionCollection) {
        print("Switch SDK did receive extractions")
        extractions = info
    }
    
    func switchSdk(sdk:GiniSwitchSdk, didReceiveError error:Error) {
        print("Switch SDK did receive an error: \(error.localizedDescription)")
    }
    
    func switchSdkDidCancel(sdk:GiniSwitchSdk) {
        print("Switch SDK interrupted")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SwitchExampleViewController: ExtractionsViewControllerDelegate {
    
    func extractionsControllerDidSwitch(_ controller:ExtractionsViewController) {
        navigationController?.popViewController(animated: true)
        switchController = nil
    }
    
    func extractionsControllerDidGoBack(_ controller:ExtractionsViewController) {
        navigationController?.popViewController(animated: false)
        guard let controller = switchController else {
            return
        }
        present(controller, animated: false, completion: nil)
    }
}
