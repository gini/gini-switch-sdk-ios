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
        }
    }
    
    var status:ScanPageStatus = .none
    
}
