//
//  MultiPageScanViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.05.17.
//
//

import UIKit

class MultiPageScanViewController: UIViewController {
    
    var coordinator:MultiPageCoordinator! = nil
    
    var cameraController:CameraViewController! = nil
    var cameraOptionsController:CameraOptionsViewController! = nil
    var pagesCollectionController:PagesCollectionViewController! = nil
    var embeddedViewController:UIViewController? = nil
    @IBOutlet var embedView:UIView! = nil
    @IBOutlet var cameraContainerView:UIView! = nil
    @IBOutlet var pageCollectionContainerView:UIView! = nil
    @IBOutlet var cameraOptionsContainerView:UIView! = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        coordinator = MultiPageCoordinator(camera: cameraController, cameraOptions: cameraOptionsController, pagesCollection: pagesCollectionController)
        coordinator.delegate = self
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

extension MultiPageScanViewController: MultiPageCoordinatorDelegate {
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedShowingController:UIViewController, presentationStyle:PresentationStyle, animated:Bool, completion: (() -> Void)?) {
        switch presentationStyle {
        case .modal:
            self.present(requestedShowingController, animated: animated, completion: completion)
        case .navigation:
            self.navigationController?.pushViewController(requestedShowingController, animated: animated)
        case .embed:
            setInEmbedView(requestedShowingController)
            break
        }
    }
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedDismissingController:UIViewController, presentationStyle:PresentationStyle, animated:Bool) {
        switch presentationStyle {
        case .modal:
            self.dismiss(animated: animated, completion: nil)
        case .navigation:
            if self.navigationController?.topViewController == requestedDismissingController {
                self.navigationController?.popViewController(animated: animated)
            }
            else {
                let requestedIndex = self.navigationController?.viewControllers.index(of: requestedDismissingController)
                guard let index = requestedIndex,
                let prevIndex = self.navigationController?.viewControllers.index(before: index),
                let prevController = self.navigationController?.viewControllers[prevIndex] else {
                    return
                }
                self.navigationController?.popToViewController(prevController, animated: animated)
            }
        case .embed:
            dismissEmbeddedController(requestedDismissingController)
        }
        
    }
    
}
