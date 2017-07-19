//
//  MultiPageCoordinator.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 16.05.17.
//
//

import UIKit

protocol MultiPageCoordinatorDelegate:class {
    
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedShowingController:UIViewController, presentationStyle:PresentationStyle, animated:Bool, completion:(() -> Void)?)
    func multiPageCoordinator(_ coordinator:MultiPageCoordinator, requestedDismissingController:UIViewController, presentationStyle:PresentationStyle, animated:Bool)
}

class MultiPageCoordinator {

    let cameraOptionsController:CameraOptionsViewController
    let cameraController:CameraViewController
    let pageCollectionController:PagesCollectionViewController
    var embeddedController:UIViewController? = nil
    
    var extractionsManager = ExtractionsManager()       // should be able to inject another one
    
    var pageToReplace:ScanPage? = nil
    var extractionsCompleted = false
    let extrationsCompletePopupTimeout = 4
    
    weak var delegate:MultiPageCoordinatorDelegate? = nil
    
    init(camera:CameraViewController, cameraOptions:CameraOptionsViewController, pagesCollection:PagesCollectionViewController) {
        cameraOptionsController = cameraOptions
        cameraController = camera
        pageCollectionController = pagesCollection
        
        cameraOptionsController.delegate = self
        cameraOptionsController.doneButtonText = currentSwitchAppearance().doneButtonText
        cameraOptionsController.textColor = currentSwitchAppearance().doneButtonTextColor
        cameraController.delegate = self
        pagesCollection.themeColor = currentSwitchAppearance().primaryColor
        pagesCollection.delegate = self
        
        extractionsManager.delegate = self
        extractionsManager.authenticate()
        self.extractionsManager.createExtractionOrder()
        currentSwitchSdk().delegate?.switchSdkDidStart(sdk: currentSwitchSdk())
        
        if !GiniSwitchOnboarding.hasShownOnboarding {
            scheduleOnboarding()
        }
    }
    
    func showReviewScreen(withPage page:ScanPage) {
        let reviewController = UIStoryboard.switchStoryboard()?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        reviewController.page = page
        reviewController.confirmColor = currentSwitchAppearance().positiveColor
        reviewController.denyColor = currentSwitchAppearance().negativeColor
        reviewController.delegate = self
        delegate?.multiPageCoordinator(self, requestedShowingController: reviewController, presentationStyle: .modal, animated: true, completion: nil)
    }
    
    fileprivate func createExtractionsScreen(extractions:ExtractionCollection) -> ExtractionsViewController {
        let extractionsController = UIStoryboard.switchStoryboard()?.instantiateViewController(withIdentifier: "ExtractionsViewController") as! ExtractionsViewController
        extractionsController.extractionsCollection = extractionsManager.extractions
        extractionsManager.pollExtractions()
        return extractionsController
    }
    
    func enableCaptureButton(_ enabled:Bool) {
        guard let button = cameraOptionsController.captureButton else {
            return
        }
        button.isEnabled = enabled
    }
    
    func refreshPagesCollectionView() {
        DispatchQueue.main.async { [weak self] () in
            guard let pages = self?.extractionsManager.scannedPages else {
                return
            }
            self?.pageCollectionController.pages = pages
            self?.pageCollectionController.pagesCollection?.reloadData()
        }
    }
    
    fileprivate func scheduleOnboarding() {
        // remove the camera button so users don't think they can tap on it
        cameraOptionsController.captureButton.isHidden = true
        let onboarding = OnboardingViewController(onboarding: (GiniSwitchSdkStorage.activeSwitchSdk?.configuration.onboarding)!, completion:nil)
        let completionDismiss = {
            GiniSwitchOnboarding.hasShownOnboarding = true
            self.delegate?.multiPageCoordinator(self, requestedDismissingController: onboarding, presentationStyle: .modal, animated: true)
            self.cameraOptionsController.captureButton.isHidden = false
        }
        onboarding.completion = completionDismiss
        onboarding.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.delegate?.multiPageCoordinator(self, requestedShowingController: onboarding, presentationStyle: .modal, animated: true, completion: nil)
        }
    }
    
    fileprivate func completeIfReady() {
        if extractionsCompleted {
            // reset the flag just in case
            extractionsCompleted = false
            // show the extractions completed screen
            let completionController = UIStoryboard.switchStoryboard()?.instantiateViewController(withIdentifier: "ExtractionsCompletedViewController") as! ExtractionsCompletedViewController
            completionController.image = currentSwitchAppearance().analyzedImage
            completionController.text = currentSwitchAppearance().analyzedText
            completionController.textSize = currentSwitchAppearance().analyzedTextSize
            completionController.textColor = currentSwitchAppearance().analyzedTextColor
            let myDelegate = delegate
            myDelegate?.multiPageCoordinator(self, requestedShowingController: completionController, presentationStyle: .modal, animated: true) { [weak self] in
                // after it is presented, push the extractions screen below it. That way, when it is
                // automatically dismissed, the extractions will appear below
                guard let weakSelf = self else {
                    return
                }
                let extractionsController = weakSelf.createExtractionsScreen(extractions:weakSelf.extractionsManager.extractions)
                weakSelf.extractionsManager.pollExtractions()
                DispatchQueue.main.async {
                    // schedule this async to avoid mixing up the transitions
                    weakSelf.delegate?.multiPageCoordinator(weakSelf, requestedShowingController: extractionsController, presentationStyle: .navigation, animated: false, completion: nil)
                }
            }
            
            // wait a few seconds so users can read the text and automatically dismiss
            let delay = DispatchTime.now() + .seconds(extrationsCompletePopupTimeout)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                myDelegate?.multiPageCoordinator(self, requestedDismissingController: completionController, presentationStyle: .modal, animated: true)
            })
        }
    }
    
    fileprivate func overflowMenu(withOnboarding:Bool) -> UIAlertController {
        let actionSheet = UIAlertController(title: currentSwitchAppearance().exitActionSheetTitle, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Abbrechen", comment: "Leave SDK actionsheet cancel title"), style: .cancel) { (action) in
            
        }
        let leaveAction = UIAlertAction(title: NSLocalizedString("Verlassen", comment: "Leave SDK actionsheet leave title"), style: .destructive) { (action) in
            currentSwitchSdk().delegate?.switchSdkDidCancel(sdk: currentSwitchSdk())
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(leaveAction)
        if withOnboarding {
            let helpAction = UIAlertAction(title: NSLocalizedString("Hilfe", comment: "Leave SDK actionsheet help title"), style: .default) { (action) in
                self.scheduleOnboarding()
            }
            actionSheet.addAction(helpAction)
        }
        return actionSheet
    }
    
    fileprivate func showOverflowMenu(withOnboarding:Bool) {
        let actionSheet = overflowMenu(withOnboarding: withOnboarding)
        self.delegate?.multiPageCoordinator(self, requestedShowingController: actionSheet, presentationStyle: .modal, animated: true, completion: nil)
    }
    
    fileprivate func embed(controller:UIViewController) {
        embeddedController = controller
        delegate?.multiPageCoordinator(self, requestedShowingController: controller, presentationStyle: .embed, animated: false, completion: nil)
    }
    
    fileprivate func removeEmbededController() {
        guard let controller = embeddedController else {
            return
        }
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: controller, presentationStyle: .embed, animated: false)
        embeddedController = nil
    }
}

extension MultiPageCoordinator: CameraOptionsViewControllerDelegate {
    
    func cameraController(cameraController:CameraOptionsViewController, didCaptureImageData:Data) {
        self.cameraController.takePicture()
        enableCaptureButton(false)
    }
    
    func cameraControllerIsDone(cameraController:CameraOptionsViewController) {
        let extractionsController = createExtractionsScreen(extractions: extractionsManager.extractions)
        extractionsManager.pollExtractions()
        delegate?.multiPageCoordinator(self, requestedShowingController: extractionsController, presentationStyle: .navigation, animated: true, completion: nil)
    }
}

extension MultiPageCoordinator: CameraViewControllerDelegate {
    
    func cameraViewController(controller:CameraViewController, didCaptureImage data:Data) {
        // create a new scan page
        let newPage = ScanPage(imageData: data, id: nil, status: .taken)
        showReviewScreen(withPage:newPage)
        enableCaptureButton(true)
        currentSwitchSdk().delegate?.switchSdk(sdk: currentSwitchSdk(), didCapture: data)
    }
    
    func cameraViewController(controller:CameraViewController, didFailWithError error:Error) {
        enableCaptureButton(true)
    }
}

extension MultiPageCoordinator: PagesCollectionViewControllerDelegate {
    
    func pageCollectionControllerDidRequestOptions(_ pageController:PagesCollectionViewController) {
        let hasEmbeddedController = (embeddedController != nil)
        showOverflowMenu(withOnboarding: !hasEmbeddedController)
    }
    
    func pageCollectionController(_ pageController:PagesCollectionViewController, didSelectPage:ScanPage) {
        pageController.shouldShowAddIcon = true
        pageController.pagesCollection?.reloadData()
        let previewController = UIStoryboard.switchStoryboard()?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        previewController.confirmColor = currentSwitchAppearance().positiveColor
        previewController.denyColor = currentSwitchAppearance().negativeColor
        previewController.page = didSelectPage
        previewController.delegate = self
        embed(controller: previewController)
    }
    
    func pageCollectionControllerDidRequestAddPage(_ pageController:PagesCollectionViewController) {
        pageController.shouldShowAddIcon = false
        pageController.pagesCollection?.reloadData()
        removeEmbededController()
    }
}

extension MultiPageCoordinator: ReviewViewControllerDelegate {
    
    func reviewController(_ controller:ReviewViewController, didAcceptPage page:ScanPage) {
        delegate?.multiPageCoordinator(self, requestedDismissingController: controller, presentationStyle: .modal, animated: true)
        if let toBeReplaced = pageToReplace {
            extractionsManager.replace(page: toBeReplaced, withPage: page)
            pageToReplace = nil
        }
        else {
            extractionsManager.add(page: page)
        }
        refreshPagesCollectionView()
        completeIfReady()
        currentSwitchSdk().delegate?.switchSdk(sdk: currentSwitchSdk(), didReview: page.imageData)
    }
    
    func reviewController(_ controller:ReviewViewController, didRejectPage page:ScanPage) {
        self.delegate?.multiPageCoordinator(self, requestedDismissingController: controller, presentationStyle: .modal, animated: true)
        completeIfReady()
    }
    
    func reviewControllerDidRequestOptions(_ controller:ReviewViewController) {
        let overflow = overflowMenu(withOnboarding: false)
        controller.present(overflow, animated: true, completion: nil)
    }
    
}

extension MultiPageCoordinator: PreviewViewControllerDelegate {
    
    func previewController(previewController:PreviewViewController, didDeletePage page:ScanPage) {
        extractionsManager.delete(page: page)
        pageCollectionController.shouldShowAddIcon = true
        refreshPagesCollectionView()
        removeEmbededController()
    }
    
    func previewController(previewController:PreviewViewController, didRequestRetake page:ScanPage) {
        pageToReplace = page
        pageCollectionController.shouldShowAddIcon = false
        pageCollectionController.pagesCollection?.reloadData()
        removeEmbededController()
    }
}

extension MultiPageCoordinator: ExtractionsManagerDelegate {
    
    func extractionsManager(_ manager:ExtractionsManager, didEncounterError error:NSError) {
        // check if it's an error that needs to be shown to the user
        if error.isHumanReadable {
            let alert = UIAlertController(title: NSLocalizedString("Fehler", comment: "Error alert view title"),
                              message: error.humanReadableDescription(),
                              preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Error alert view button title"),
                                         style: .default,
                                         handler: nil)
            alert.addAction(okAction)
            delegate?.multiPageCoordinator(self, requestedShowingController: alert, presentationStyle: .modal, animated: true, completion: nil)
        }
    }
    
    func extractionsManager(_ manager:ExtractionsManager, didChangePageCollection collection:PageCollection) {
        refreshPagesCollectionView()
    }
    
    func extractionsManager(_ manager:ExtractionsManager, didChangeExtractions extractions:ExtractionCollection) {
        
    }
    
    func extractionsManagerDidAuthenticate(_ manager:ExtractionsManager) {
        
    }
    
    func extractionsManagerDidCreateOrder(_ manager:ExtractionsManager) {
        
    }
    
    func extractionsManagerDidCompleteExtractions(_ manager:ExtractionsManager) {
        // Don't interrupt the user immediately. Allow them to complete the last action
        // before notifying them that extractions are complete
        extractionsCompleted = true
    }
    
}
