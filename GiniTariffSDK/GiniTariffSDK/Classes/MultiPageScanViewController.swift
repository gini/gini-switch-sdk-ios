//
//  MultiPageScanViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 09.05.17.
//
//

import UIKit

class MultiPageScanViewController: UIViewController {
    
    var coordinator:MultiPageCoordinator! = nil
    
    var cameraController:CameraViewController! = nil
    var cameraOptionsController:CameraOptionsViewController! = nil
    var pagesCollectionController:PagesCollectionViewController! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        coordinator = MultiPageCoordinator(camera: cameraController, cameraOptions: cameraOptionsController, pagesCollection: pagesCollectionController)
        coordinator.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MultiPageScanViewController: MultiPageCoordinatorDelegate {
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedShowingController:UIViewController) {
        self.present(requestedShowingController, animated: true, completion: nil)
    }
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedDismissingController:UIViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
