//
//  PageCollectionViewCell.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 11.05.17.
//
//

import UIKit

enum PageStatus {
    case none
    case failed
    case ok
}

class PageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var pagePreview:UIImageView! = nil
    @IBOutlet var pageStatusView:UIImageView! = nil
    @IBOutlet var pageStatusUnderlineView:UIImageView! = nil
    
    var image:UIImage? = nil {
        didSet {
            pagePreview.image = image
        }
    }
    
    var status:PageStatus = .none
    
}
