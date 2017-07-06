//
//  HardcodedProviderViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 06.07.17.
//
//

import UIKit

class HardcodedProviderViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

}
