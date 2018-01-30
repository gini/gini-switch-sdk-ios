//
//  MultiPageScanViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.05.17.
//
//

import UIKit

final class MultiPageScanViewController: UIViewController {
    
    var cameraController:CameraViewController! = nil
    var cameraOptionsController:CameraOptionsViewController! = nil
    var pagesCollectionController:PagesCollectionViewController! = nil
    var embeddedViewController:UIViewController?
    @IBOutlet var embedView:UIView! = nil
    @IBOutlet var cameraContainerView:UIView! = nil
    @IBOutlet var pageCollectionContainerView:UIView! = nil
    @IBOutlet var cameraOptionsContainerView:UIView! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var prefersStatusBarHidden:Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: it would be nice if the following switch is only executed on "embed" segues
        switch segue.identifier! {
        case "CameraViewControllerEmbed":
            cameraController = segue.destination as? CameraViewController
        case "CameraOptionsViewControllerEmbed":
            cameraOptionsController = segue.destination as? CameraOptionsViewController
        case "PagesCollectionViewControllerEmbed":
            pagesCollectionController = segue.destination as? PagesCollectionViewController
            
        default:
            // do nothing
            break
        }
    }

}

extension MultiPageScanViewController {
    
    func present(controller:UIViewController,
                 presentationStyle:PresentationStyle,
                 animated:Bool,
                 completion: (() -> Void)?) {
        switch presentationStyle {
        case .modal:
            // there might be a controller already presented. If so, this one needs to be presented on top of it
            let presentationController = self.presentedViewController ?? self
            presentationController.present(controller, animated: animated, completion: completion)
        case .navigation:
            self.navigationController?.pushViewController(controller, animated: animated)
        case .embed:
            setInEmbedView(controller)
        }
    }
    
    func dismiss(controller:UIViewController,
                 presentationStyle:PresentationStyle,
                 animated:Bool,
                 completion: (() -> Void)?) {
        switch presentationStyle {
        case .modal:
            controller.presentingViewController?.dismiss(animated: animated, completion: completion)
        case .navigation:
            if self.navigationController?.topViewController == controller {
                self.navigationController?.popViewController(animated: animated)
            } else {
                let requestedIndex = self.navigationController?.viewControllers.index(of: controller)
                guard let index = requestedIndex,
                let prevIndex = self.navigationController?.viewControllers.index(before: index),
                let prevController = self.navigationController?.viewControllers[prevIndex] else {
                    return
                }
                self.navigationController?.popToViewController(prevController, animated: animated)
            }
        case .embed:
            dismissEmbeddedController(controller)
        }
        
    }
    
    func setInEmbedView(_ childController:UIViewController) {
        if embeddedViewController != nil {
            dismissEmbeddedController(embeddedViewController!)
        }
        self.addChildViewController(childController)
        childController.view.frame = embedView.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        embedView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
        embedView.isHidden = false
        cameraContainerView.isHidden = true
        cameraOptionsContainerView.isHidden = true
    }
    
    func dismissEmbeddedController(_ controller:UIViewController) {
        controller.removeFromParentViewController()
        controller.view.removeFromSuperview()
        embedView.isHidden = true
        cameraContainerView.isHidden = false
        cameraOptionsContainerView.isHidden = false
    }
    
}
