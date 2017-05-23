//
//  TariffUserInterface.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

import UIKit

struct TariffUserInterface {
    
    var presentationStyle = PresentationStyle.modal
    
    var initialViewController:UIViewController {
        var initialController:UIViewController? = nil
        switch presentationStyle {
        case .modal:
            let navController = UINavigationController(rootViewController:contentViewController)
            initialController = navController
        case .navigation:
            initialController = contentViewController
        }
        return initialController!
    }
    
    private var contentViewController:UIViewController {
        let storyboard = UIStoryboard(name: "Tariff", bundle: Bundle(identifier:"org.cocoapods.GiniTariffSDK"))    // TODO: duplication with TestUtils
        return storyboard.instantiateInitialViewController()!
    }

}
