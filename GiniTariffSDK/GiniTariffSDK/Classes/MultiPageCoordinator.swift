//
//  MultiPageCoordinator.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 16.05.17.
//
//

import UIKit

protocol MultiPageCoordinatorDelegate:class {
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedShowingController:UIViewController, presentationStyle:PresentationStyle)
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedDismissingController:UIViewController, presentationStyle:PresentationStyle)
}

class MultiPageCoordinator {

    let cameraOptionsController:CameraOptionsViewController
    let cameraController:CameraViewController
    let pageCollectionController:PagesCollectionViewController
    var embeddedController:UIViewController? = nil
    
    weak var delegate:MultiPageCoordinatorDelegate? = nil
    
    init(camera:CameraViewController, cameraOptions:CameraOptionsViewController, pagesCollection:PagesCollectionViewController) {
        cameraOptionsController = cameraOptions
        cameraController = camera
        pageCollectionController = pagesCollection
        
        cameraOptionsController.delegate = self
        cameraController.delegate = self
        pagesCollection.delegate = self
    }
    
    func showReviewScreen(withPage page:ScanPage) {
        let reviewController = UIStoryboard.tariffStoryboard()?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        reviewController.page = page
        reviewController.delegate = self
        delegate?.multiPageCoordinator(self, requestedShowingController: reviewController, presentationStyle: .modal)
    }
}

extension MultiPageCoordinator: CameraOptionsViewControllerDelegate {
    
    func cameraController(cameraController:CameraOptionsViewController, didCaptureImageData:Data) {
        self.cameraController.takePicture()
    }
    
    func cameraControllerIsDone(cameraController:CameraOptionsViewController) {
        let extractionsController = UIStoryboard.tariffStoryboard()?.instantiateViewController(withIdentifier: "ExtractionsViewController") as! ExtractionsViewController
        // TODO: these are hardcoded extractions for test purposes. In the future, they should come from the API
        let extractions = ["Name": "Holger", "Adresse": "Sonnenstr.", "Ort": "München", "Zählernummer": "439057928376"]
        let collection = ExtractionCollection(dictionary: extractions)
        extractionsController.extractionsCollection = collection
        delegate?.multiPageCoordinator(self, requestedShowingController: extractionsController, presentationStyle: .navigation)
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

extension MultiPageCoordinator: PagesCollectionViewControllerDelegate {
    
    func pageCollectionControllerDidRequestOptions(_ pageController:PagesCollectionViewController) {
         // show an action sheet with all possible action
        let actionSheet = UIAlertController(title: NSLocalizedString("Gini Switch verlassen", comment: "Leave SDK actionsheet title"), message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Abbrechen", comment: "Leave SDK actionsheet cancel title"), style: .cancel) { (action) in
            
        }
        let leaveAction = UIAlertAction(title: NSLocalizedString("Verlassen", comment: "Leave SDK actionsheet leave title"), style: .destructive) { (action) in
            TariffSdkStorage.activeTariffSdk?.delegate?.tariffSdkDidCancel(sdk: TariffSdkStorage.activeTariffSdk!)
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(leaveAction)
        self.delegate?.multiPageCoordinator(self, requestedShowingController: actionSheet, presentationStyle: .modal)
    }
    
    func pageCollectionController(_ pageController:PagesCollectionViewController, didSelectPage:ScanPage) {
        let previewController = UIStoryboard.tariffStoryboard()?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        previewController.page = didSelectPage
        previewController.delegate = self
        embeddedController = previewController
        delegate?.multiPageCoordinator(self, requestedShowingController: previewController, presentationStyle: .embed)
    }
    
    func pageCollectionControllerDidRequestAddPage(_ pageController:PagesCollectionViewController) {
        guard let controller = self.embeddedController else {
            return
        }
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: controller, presentationStyle: .embed)
    }
}

extension MultiPageCoordinator: ReviewViewControllerDelegate {
    
    func reviewController(_ controller:ReviewViewController, didAcceptPage page:ScanPage) {
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: controller, presentationStyle: .modal)
        self.pageCollectionController.pagesCollection?.reloadData()
    }
    
    func reviewController(_ controller:ReviewViewController, didRejectPage page:ScanPage) {
        pageCollectionController.pages?.remove(page)
        self.pageCollectionController.pagesCollection?.reloadData()
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: controller, presentationStyle: .modal)
    }
    
}

extension MultiPageCoordinator: PreviewViewControllerDelegate {
    
    func previewController(previewController:PreviewViewController, didDeletePage page:ScanPage) {
        pageCollectionController.pages?.remove(page)
        self.pageCollectionController.pagesCollection?.reloadData()
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: previewController, presentationStyle: .embed)
    }
    
    func previewController(previewController:PreviewViewController, didRequestRetake page:ScanPage) {
        // TODO: now it's the same as deleting the image. Figure out a way to retake
        pageCollectionController.pages?.remove(page)
        self.pageCollectionController.pagesCollection?.reloadData()
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: previewController, presentationStyle: .embed)
    }
}
