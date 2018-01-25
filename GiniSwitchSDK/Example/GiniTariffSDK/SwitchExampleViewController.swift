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
    
    var extractions:ExtractionCollection?
    var switchController:UIViewController? = nil
    var sdk:GiniSwitchSdk? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStartSdk() {
        sdk = SdkBuilder.customizedSwitchSdk()
        sdk?.delegate = self
        switchController = sdk?.instantiateSwitchViewController()
        self.present(switchController!, animated: true, completion: nil)
    }
    
    fileprivate func createExtractionsScreen(extractions:ExtractionCollection?) -> ExtractionsViewController {
        let extractionsController = storyboard?.instantiateViewController(withIdentifier: "ExtractionsViewController") as! ExtractionsViewController
        extractionsController.extractionsCollection = extractions
        extractionsController.delegate = self
        return extractionsController
    }
    
    fileprivate func showExtractions(extractions:ExtractionCollection?) {
        navigationController?.pushViewController(createExtractionsScreen(extractions: extractions), animated: false)
    }
    
    fileprivate func terminateSdk() {
        switchController = nil
        sdk = nil
        extractions = nil        // release the collection
    }

}

extension SwitchExampleViewController: GiniSwitchSdkDelegate {
    
    func switchSdkDidComplete(_ sdk:GiniSwitchSdk) {
        print("Switch SDK completed")
        self.showExtractions(extractions: self.extractions)
        self.dismiss(animated: true, completion: nil)
    }
    
    func switchSdk(_ sdk:GiniSwitchSdk, didChangeExtractions info:ExtractionCollection) {
        print("Switch SDK did receive extractions")
        extractions = info
    }
    
    func switchSdk(_ sdk:GiniSwitchSdk, didReceiveError error:NSError) {
        print("Switch SDK did receive an error: \(error.localizedDescription)")
        if error.switchErrorCode == .feedbackError {
            terminateSdk()
        }
    }
    
    func switchSdkDidCancel(_ sdk:GiniSwitchSdk) {
        print("Switch SDK interrupted")
        self.dismiss(animated: true, completion: nil)
    }
    
    func switchSdkDidSendFeedback(_ sdk:GiniSwitchSdk) {
        terminateSdk()
    }
    
}

extension SwitchExampleViewController: ExtractionsViewControllerDelegate {
    
    func extractionsControllerDidSwitch(_ controller:ExtractionsViewController) {
        navigationController?.popViewController(animated: true)
        // before the SDK is teminated, send feedback
        if let feedback = controller.extractionsCollection {
            sdk?.sendFeedback(feedback)
        }
        else {
            terminateSdk()
        }
    }
    
    func extractionsControllerDidGoBack(_ controller:ExtractionsViewController) {
        navigationController?.popViewController(animated: false)
        guard let controller = switchController else {
            return
        }
        present(controller, animated: false, completion: nil)
    }
}
