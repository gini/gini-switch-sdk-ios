//
//  PageCollectionViewCell.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 11.05.17.
//
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var pagePreview:UIImageView! = nil
    @IBOutlet var pageStatusView:UIImageView! = nil
    @IBOutlet var pageStatusUnderlineView:UIImageView! = nil
    @IBOutlet var addPageLabel:UILabel! = nil
    @IBOutlet var uploadingIndicator:UIActivityIndicatorView! = nil
    @IBOutlet var pageNumberLabel:UILabel! = nil
    
    var pageSelectionLayer:CALayer? = nil
    
    var image:UIImage? = nil {
        didSet {
            pagePreview.image = image
        }
    }
    
    var page:ScanPage? = nil {
        didSet {
            guard let data = page?.imageData,
            let pageStatus = page?.status else {
                // TODO log error
                return
            }
            image = UIImage(data: data)
            status = pageStatus
            addPageLabel.isHidden = true
            pageStatusUnderlineView.isHidden = false
        }
    }
    
    var pageNumber:UInt? {
        didSet {
            if let number = pageNumber {
                let photoString = NSLocalizedString("Foto", comment: "Page collection cell page number text")
                pageNumberLabel.text = "\(photoString) \(number)"
            }
            else {
                pageNumberLabel.text = ""
            }
        }
    }
    
    var status:ScanPageStatus = .none {
        didSet {
            switch status {
            case .analysed:
                pageStatusUnderlineView.isHidden = false
                pageStatusView.isHidden = false
                pageStatusUnderlineView.backgroundColor = TariffSdkStorage.activeTariffSdk?.appearance.positiveColor
                // TODO: write a wrapper for accessing the framework bundle
                pageStatusView.image = UIImage(named: "pageUploadSuccessCheckmarkCircle", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)
                uploadingIndicator.isHidden = true
            case .failed:
                pageStatusUnderlineView.isHidden = false
                pageStatusView.isHidden = false
                pageStatusUnderlineView.backgroundColor = TariffSdkStorage.activeTariffSdk?.appearance.negativeColor
                pageStatusView.image = UIImage(named: "pageUploadFailedCrossCircle", in: Bundle(identifier: "org.cocoapods.GiniTariffSDK"), compatibleWith: nil)
                uploadingIndicator.isHidden = true
            case .uploading, .uploaded:
                pageStatusUnderlineView.isHidden = true
                pageStatusView.isHidden = true
                uploadingIndicator.isHidden = false
                uploadingIndicator.startAnimating()
            default:
                pageStatusUnderlineView.isHidden = true
                pageStatusView.isHidden = true
                uploadingIndicator.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        let dashLayer = CALayer.dashOutlineLayer(frame: self.pagePreview.bounds, color: UIColor.white)
        dashLayer.isHidden = true
        pageSelectionLayer = dashLayer
        self.pagePreview.layer.addSublayer(dashLayer)
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            pageSelectionLayer?.isHidden = !newValue
        }
    }
    
}
