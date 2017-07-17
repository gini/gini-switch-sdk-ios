//
//  GiniSwitchUserInterface.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

import UIKit

struct GiniSwitchUserInterface {
    
    var presentationStyle = PresentationStyle.modal
    
    var initialViewController:UIViewController {
        var initialController:UIViewController? = nil
        switch presentationStyle {
        case .modal:
            let navController = UINavigationController(rootViewController:contentViewController)
            initialController = navController
        case .navigation:
            initialController = contentViewController
        case .embed:
            assertionFailure("Embedding is not yet supported")
        }
        return initialController!
    }
    
    private var contentViewController:UIViewController {
        let storyboard = UIStoryboard.switchStoryboard()!
        return storyboard.instantiateInitialViewController()!
    }

}