//
//  PageCollectionViewCell.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 11.05.17.
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
    
    var pageSelectionLayer:CAShapeLayer? = nil
    var pageSelectionColor:UIColor = UIColor.white {
        didSet {
            pageSelectionLayer?.changeOutlineColor(with:pageSelectionColor)
        }
    }
    
    var pageUploadedImage = UIImage(named: "pageUploadSuccessCheckmarkCircle", in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"), compatibleWith: nil)
    var pageFailedImage = UIImage(named: "pageUploadFailedCrossCircle", in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"), compatibleWith: nil)
    
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
                pageStatusUnderlineView.backgroundColor = GiniSwitchSdkStorage.activeSwitchSdk?.appearance.positiveColor
                // TODO: write a wrapper for accessing the framework bundle
                pageStatusView.image = pageUploadedImage
                uploadingIndicator.isHidden = true
            case .failed:
                pageStatusUnderlineView.isHidden = false
                pageStatusView.isHidden = false
                pageStatusUnderlineView.backgroundColor = GiniSwitchSdkStorage.activeSwitchSdk?.appearance.negativeColor
                pageStatusView.image = pageFailedImage
                uploadingIndicator.isHidden = true
            case .uploading, .uploaded, .replaced:
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
    
    var shouldShowPlus:Bool = false {
        didSet {
            addPageLabel.isHidden = !shouldShowPlus
        }
    }
    
    func setupForAddButton() {
        pagePreview.image = nil
        pageStatusUnderlineView.image = nil
        pageStatusUnderlineView.backgroundColor = UIColor.clear
        pageStatusView.image = nil
        uploadingIndicator.isHidden = true
    }
    
    override func awakeFromNib() {
        let dashLayer = CAShapeLayer.dashOutlineLayer(frame: self.pagePreview.bounds, color: pageSelectionColor)
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
