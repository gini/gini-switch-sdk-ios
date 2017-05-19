//
//  MultiPageCoordinator.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 16.05.17.
//
//

import UIKit

protocol MultiPageCoordinatorDelegate:class {
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedShowingController:UIViewController)
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedDismissingController:UIViewController)
}

class MultiPageCoordinator {

    let cameraOptionsController:CameraOptionsViewController
    let cameraController:CameraViewController
    let pageCollectionController:PagesCollectionViewController
    
    weak var delegate:MultiPageCoordinatorDelegate? = nil
    
    init(camera:CameraViewController, cameraOptions:CameraOptionsViewController, pagesCollection:PagesCollectionViewController) {
        cameraOptionsController = cameraOptions
        cameraController = camera
        pageCollectionController = pagesCollection
        
        cameraOptionsController.delegate = self
        cameraController.delegate = self
    }
    
    func showReviewScreen(withPage page:ScanPage) {
        let reviewController = UIStoryboard.tariffStoryboard()?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        reviewController.page = page
        reviewController.delegate = self
        delegate?.multiPageCoordinator(self, requestedShowingController: reviewController)
    }
}

extension MultiPageCoordinator: CameraOptionsViewControllerDelegate {
    
    func cameraController(cameraController:CameraOptionsViewController, didCaptureImageData:Data) {
        self.cameraController.takePicture()
    }
    
    func cameraControllerIsDone(cameraController:CameraOptionsViewController) {
        
    }
}

extension MultiPageCoordinator: CameraViewControllerDelegate {
    
    func cameraViewController(controller:CameraViewController, didCaptureImage data:Data) {
        // create a new scan page
        let newPage = ScanPage(imageData: data, id: nil, status: .taken)
        self.pageCollectionController.pages?.add(element: newPage)
        showReviewScreen(withPage:newPage)
    }
    
    func cameraViewController(controller:CameraViewController, didFailWithError error:Error) {
        
    }
}

extension MultiPageCoordinator: ReviewViewControllerDelegate {
    
    func reviewController(_ controller:ReviewViewController, didAcceptPage page:ScanPage) {
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: controller)
        self.pageCollectionController.pagesCollection?.reloadData()
    }
    
    func reviewController(_ controller:ReviewViewController, didRejectPage page:ScanPage) {
        pageCollectionController.pages?.remove(page)
        self.pageCollectionController.pagesCollection?.reloadData()
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: controller)
    }
    
}
