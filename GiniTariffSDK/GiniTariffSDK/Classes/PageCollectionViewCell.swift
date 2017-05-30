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
    
    var status:ScanPageStatus = .none {
        didSet {
            switch status {
            case .analysed, .taken: // TODO: just for Dummy SDK - remove after
                pageStatusUnderlineView.backgroundColor = TariffSdkStorage.activeTariffSdk?.appearance.positiveColor
            case .failed:
                pageStatusUnderlineView.backgroundColor = TariffSdkStorage.activeTariffSdk?.appearance.negativeColor
            default:
                pageStatusUnderlineView.backgroundColor = UIColor.clear
            }
        }
    }
    
}
