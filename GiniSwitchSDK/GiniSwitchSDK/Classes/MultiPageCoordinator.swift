//
//  MultiPageCoordinator.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 16.05.17.
//
//

import UIKit

protocol MultiPageCoordinatorDelegate:class {
    
    func multiPageCoordinatorDidComplete(_ coordinator:MultiPageCoordinator)
    func multiPageCoordinatorDidCancel(_ coordinator:MultiPageCoordinator)
    
}

class MultiPageCoordinator {
    
    let extractionsManager:ExtractionsManager
    let onboarding:GiniSwitchOnboarding

    let multiPageViewController:MultiPageScanViewController
    var embeddedController:UIViewController?
    
    var presentationStyle = PresentationStyle.modal
    
    var pageToReplace:ScanPage?
    var pageToPreUpload:ScanPage?
    var extractionsCompleted = false
    var shouldShowCompletionScreen = true
    let extrationsCompletePopupTimeout = 4
    
    weak var delegate:MultiPageCoordinatorDelegate?
    
    var cameraOptionsController:CameraOptionsViewController {
        return multiPageViewController.cameraOptionsController
    }
    
    var cameraController:CameraViewController {
        return multiPageViewController.cameraController
    }
    
    var pageCollectionController:PagesCollectionViewController {
        return multiPageViewController.pagesCollectionController
    }
    
    init(extractionsManager:ExtractionsManager, onboarding:GiniSwitchOnboarding) {
        self.extractionsManager = extractionsManager
        self.onboarding = onboarding
        multiPageViewController = MultiPageCoordinator.contentViewController
        _ = multiPageViewController.view
        
        cameraOptionsController.delegate = self
        cameraOptionsController.doneButtonText = GiniSwitchAppearance.doneButtonText
        cameraOptionsController.textColor = GiniSwitchAppearance.doneButtonTextColor
        cameraController.delegate = self
        pageCollectionController.themeColor = GiniSwitchAppearance.primaryColor
        pageCollectionController.delegate = self
        
        extractionsManager.authenticate()
        self.extractionsManager.createExtractionOrder()
        
        if !GiniSwitchOnboarding.hasShownOnboarding {
            scheduleOnboarding()
        }
    }
    
    var initialViewController:UIViewController {
        var initialController:UIViewController? = nil
        switch presentationStyle {
        case .modal:
            let navController = UINavigationController(rootViewController:multiPageViewController)
            initialController = navController
        case .navigation:
            initialController = multiPageViewController
        case .embed:
            assertionFailure("Embedding is not yet supported")
        }
        return initialController!
    }
    
    static private var contentViewController:MultiPageScanViewController {
        let storyboard = UIStoryboard.switchStoryboard()!
        return storyboard.instantiateInitialViewController() as! MultiPageScanViewController
    }
    
    func showReviewScreen(withPage page:ScanPage) {
        let reviewController = UIStoryboard.switchStoryboard()?
            .instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        reviewController.page = page.copy() as? ScanPage
        reviewController.themeColor = GiniSwitchAppearance.primaryColor
        reviewController.confirmColor = GiniSwitchAppearance.positiveColor
        reviewController.denyColor = GiniSwitchAppearance.negativeColor
        reviewController.delegate = self
        multiPageViewController.present(controller: reviewController,
                                        presentationStyle: .modal,
                                        animated: true,
                                        completion: nil)
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
    
    func displayError(_ error:NSError) {
        let alert = UIAlertController(title: NSLocalizedString("Fehler", comment: "Error alert view title"),
                                      message: error.humanReadableDescription(),
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Error alert view button title"),
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        multiPageViewController.present(controller: alert, presentationStyle: .modal, animated: true, completion: nil)
    }
    
    fileprivate func scheduleOnboarding() {
        // remove the camera button so users don't think they can tap on it
        cameraOptionsController.captureButton.isHidden = true
        let onboardingController = OnboardingViewController(onboarding: onboarding, completion:nil)
        let completionDismiss = {
            GiniSwitchOnboarding.hasShownOnboarding = true
            self.multiPageViewController.dismiss(controller: onboardingController,
                                                 presentationStyle: .modal,
                                                 animated: true,
                                                 completion: nil)
            self.cameraOptionsController.captureButton.isHidden = false
        }
        onboardingController.completion = completionDismiss
        onboardingController.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.multiPageViewController.present(controller: onboardingController,
                                                 presentationStyle: .modal,
                                                 animated: true,
                                                 completion: nil)
        }
    }
    
    fileprivate func completeIfReady() {
        if extractionsCompleted {
            // reset the flag just in case
            extractionsCompleted = false
            if shouldShowCompletionScreen {
                // show the extractions completed screen
                let completionController = UIStoryboard.switchStoryboard()?
                    .instantiateViewController(withIdentifier: "ExtractionsCompletedViewController")
                    as! ExtractionsCompletedViewController
                completionController.image = GiniSwitchAppearance.analyzedImage
                completionController.text = GiniSwitchAppearance.analyzedText
                completionController.textSize = GiniSwitchAppearance.analyzedTextSize
                completionController.textColor = GiniSwitchAppearance.analyzedTextColor
                multiPageViewController.present(controller: completionController,
                                                presentationStyle: .modal,
                                                animated: true) { [weak self] in
                    // after it is presented, push the extractions screen below it. That way, when it is
                    // automatically dismissed, the extractions will appear below
                    guard let `self` = self else {
                        return
                    }
                    self.extractionsManager.pollExtractions()
                }
                
                // wait a few seconds so users can read the text and automatically dismiss
                let delay = DispatchTime.now() + .seconds(extrationsCompletePopupTimeout)
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    self.multiPageViewController.dismiss(controller: completionController,
                                                         presentationStyle: .modal,
                                                         animated: true) {
                        self.delegate?.multiPageCoordinatorDidComplete(self)
                    }
                })
            } else {
                self.delegate?.multiPageCoordinatorDidComplete(self)
            }
        }
    }
    
    fileprivate func overflowMenu() -> UIAlertController {
        let actionSheet = UIAlertController(title: GiniSwitchAppearance.exitActionSheetTitle,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Abbrechen",
                                                                  comment: "Leave SDK actionsheet cancel title"),
                                         style: .cancel) { (_) in
            
        }
        let leaveAction = UIAlertAction(title: NSLocalizedString("Verlassen",
                                                                 comment: "Leave SDK actionsheet leave title"),
                                        style: .destructive) { (_) in
            self.delegate?.multiPageCoordinatorDidCancel(self)
        }
        let helpAction = UIAlertAction(title: NSLocalizedString("Hilfe",
                                                                comment: "Leave SDK actionsheet help title"),
                                       style: .default) { (_) in
            self.scheduleOnboarding()
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(leaveAction)
        actionSheet.addAction(helpAction)
        return actionSheet
    }
    
    fileprivate func showOverflowMenu() {
        let actionSheet = overflowMenu()
        multiPageViewController.present(controller: actionSheet,
                                        presentationStyle: .modal,
                                        animated: true,
                                        completion: nil)
    }
    
    fileprivate func embed(controller:UIViewController) {
        embeddedController = controller
        multiPageViewController.present(controller: controller,
                                        presentationStyle: .embed,
                                        animated: false,
                                        completion: nil)
    }
    
    fileprivate func removeEmbededController() {
        guard let controller = embeddedController else {
            return
        }
        multiPageViewController.dismiss(controller: controller,
                                        presentationStyle: .embed,
                                        animated: false,
                                        completion: nil)
        embeddedController = nil
    }
}

extension MultiPageCoordinator: CameraOptionsViewControllerDelegate {
    
    func cameraController(cameraController:CameraOptionsViewController, didCaptureImageData:Data) {
        self.cameraController.takePicture()
        enableCaptureButton(false)
    }
    
    func cameraControllerIsDone(cameraController:CameraOptionsViewController) {
        extractionsManager.pollExtractions()
        delegate?.multiPageCoordinatorDidComplete(self)
    }
}

extension MultiPageCoordinator: CameraViewControllerDelegate {
    
    func cameraViewController(controller:CameraViewController, didCaptureImage data:Data) {
        // create a new scan page and put all the EXIF tags (the image metadata)
        let metaInformationManager = ImageMetaInformationManager(imageData:data)
        guard let image = metaInformationManager.imageData() else {
            return
        }
        let newPage = ScanPage(imageData: image, id: nil, status: .taken)
        if pageToReplace == nil {
            // don't pre-upload if the image is being replaced
            extractionsManager.add(page: newPage)
        }
        pageToPreUpload = newPage
        showReviewScreen(withPage:newPage)
        enableCaptureButton(true)
    }
    
    func cameraViewController(controller:CameraViewController, didFailWithError error:Error) {
        enableCaptureButton(true)
    }
}

extension MultiPageCoordinator: PagesCollectionViewControllerDelegate {
    
    func pageCollectionControllerDidRequestOptions(_ pageController:PagesCollectionViewController) {
        showOverflowMenu()
    }
    
    func pageCollectionController(_ pageController:PagesCollectionViewController, didSelectPage:ScanPage) {
        pageController.shouldShowAddIcon = true
        pageController.pagesCollection?.reloadData()
        let previewController = UIStoryboard.switchStoryboard()?
            .instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        previewController.confirmColor = GiniSwitchAppearance.positiveColor
        previewController.denyColor = GiniSwitchAppearance.negativeColor
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
        multiPageViewController.dismiss(controller: controller, presentationStyle: .modal, animated: true) {
            DispatchQueue.main.async {
                self.completeIfReady()
            }
        }

        if let toBeReplaced = pageToReplace {
            toBeReplaced.status = .replaced
            extractionsManager.replace(page: toBeReplaced, withPage: page)
            pageToReplace = nil
            // the camera view will be shown after this, so the add page cell needs to be selected.
            // Otherwise, the page that was just replaced, will remain in selected state
            pageCollectionController.goToAddPage()
        } else {
            if page.imageData != pageToPreUpload?.imageData,
                let preuploadedPage = pageToPreUpload {
                // the page changed after it got pre-uploaded
                preuploadedPage.status = .replaced
                extractionsManager.replace(page: preuploadedPage, withPage: page)
            }
        }
        pageToPreUpload = nil
        refreshPagesCollectionView()
    }
    
    func reviewController(_ controller:ReviewViewController, didRejectPage page:ScanPage) {
        multiPageViewController.dismiss(controller: controller, presentationStyle: .modal, animated: true) {
            DispatchQueue.main.async {
                self.completeIfReady()
            }
        }
        if let preuploadedPage = pageToPreUpload {
            extractionsManager.delete(page: preuploadedPage)
        }
        pageToPreUpload = nil
    }
    
    func reviewControllerDidRequestOptions(_ controller:ReviewViewController) {
        let overflow = overflowMenu()
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
