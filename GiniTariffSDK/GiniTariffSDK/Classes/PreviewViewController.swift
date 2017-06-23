//
//  PreviewViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 24.05.17.
//
//

import UIKit

protocol PreviewViewControllerDelegate:class {
    
    func previewController(previewController:PreviewViewController, didDeletePage page:ScanPage)
    func previewController(previewController:PreviewViewController, didRequestRetake page:ScanPage)
}

class PreviewViewController: UIViewController {
    
    @IBOutlet var pagePreview:UIImageView! = nil
    @IBOutlet var titleLabel:UILabel! = nil
    @IBOutlet var retakeButton:UIButton! = nil
    @IBOutlet var deleteButton:UIButton! = nil
    @IBOutlet var statusImageView:UIImageView! = nil
    
    weak var delegate:PreviewViewControllerDelegate? = nil
    
    //titles
    let analysedPageTitle = NSLocalizedString("Sehr gut, wir könnten alle Daten aus diesem Foto erfolgreich analysieren.", comment: "Preview screen title - analysed document")
    let failedPageTitle = NSLocalizedString("Leider ist die Qualität dieser Seite nicht ausreichend. Bitte fotografiere diese Seite nochmal neu.", comment: "Preview screen title - failed document")
    
    var page:ScanPage? = nil {
        didSet {
            populate(with:page)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        populate(with: page)
    }
    
    private func populate(with page:ScanPage?) {
        guard let page = page,
            let imageData = page.imageData,
            let previewImageView = pagePreview,
            let statusView = statusImageView,
            let titleView = titleLabel else { return }
        previewImageView.image = UIImage(data: imageData)
        switch page.status {
        case .analysed:
            // add the "Ok" marker in the middle of the preview
            // change the title text accordingly
            statusView.image = UIImage(named: "pageUploadSuccessCheckmarkCircle", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)
            titleView.text = analysedPageTitle
            break
        case .failed:
            // add the "X" marker in the middle of the preview
            // change the title text accordingly
            statusView.image = UIImage(named: "pageUploadFailedCrossCircle", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)
            titleView.text = failedPageTitle
            break
        default:
            break
        }
    }

    @IBAction func onDeleteTapped() {
        guard let page = self.page else {
            return
        }
        self.delegate?.previewController(previewController: self, didDeletePage: page)
    }
    
    @IBAction func onRetakeTapped() {
        guard let page = self.page else {
            return
        }
        self.delegate?.previewController(previewController: self, didRequestRetake: page)
    }
}
