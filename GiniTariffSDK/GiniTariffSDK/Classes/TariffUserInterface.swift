//
//  TariffUserInterface.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

import UIKit

enum TariffPresentationStyle {
    case modal
    case navigation
}

struct TariffUserInterface {
    
    var presentationStyle = TariffPresentationStyle.modal
    
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
        return UIViewController()
    }

}
