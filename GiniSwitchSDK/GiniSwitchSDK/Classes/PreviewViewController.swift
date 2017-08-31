//
//  PreviewViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 24.05.17.
//
//

import UIKit

protocol PreviewViewControllerDelegate:class {
    
    func previewController(previewController:PreviewViewController, didDeletePage page:ScanPage)
    func previewController(previewController:PreviewViewController, didRequestRetake page:ScanPage)
}

class PreviewViewController: UIViewController {
    
    @IBOutlet var pagePreview:ZoomableImageView! = nil
    @IBOutlet var titleLabel:UILabel! = nil
    @IBOutlet var retakeButton:UIButton! = nil
    @IBOutlet var deleteButton:UIButton! = nil
    
    weak var delegate:PreviewViewControllerDelegate? = nil
    
    //titles
    let analysedPageTitle = GiniSwitchAppearance.imageProcessedText
    let failedPageTitle = GiniSwitchAppearance.imageProcessFailedText
    
    var page:ScanPage? = nil {
        didSet {
            populate(with:page)
        }
    }
    
    var confirmColor:UIColor? = nil
    var denyColor:UIColor? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        populate(with: page)
        setupButtonColors()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pagePreview.updateMinZoomScaleForSize(pagePreview.bounds.size)
    }
    
    private func populate(with page:ScanPage?) {
        guard let page = page,
            let previewImageView = pagePreview,
            let titleView = titleLabel else { return }
        previewImageView.image = UIImage(data: page.imageData)
        switch page.status {
        case .analysed:
            // change the title text accordingly
            titleView.text = analysedPageTitle
            break
        case .failed:
            // change the title text accordingly
            titleView.text = failedPageTitle
            break
        default:
            break
        }
    }
    
    private func setupButtonColors() {
        if let confirmColor = confirmColor {
            retakeButton.backgroundColor = confirmColor
        }
        if let denyColor = denyColor {
            deleteButton.backgroundColor = denyColor
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
