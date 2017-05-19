//
//  ReviewViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 17.05.17.
//
//

import UIKit

protocol ReviewViewControllerDelegate {
    
    func reviewController(_ controller:ReviewViewController, didAcceptPage page:ScanPage)
    func reviewController(_ controller:ReviewViewController, didRejectPage page:ScanPage)
    
}

class ReviewViewController: UIViewController {
    
    @IBOutlet var useButton:UIButton! = nil
    @IBOutlet var retakeButton:UIButton! = nil
    @IBOutlet var rotateButton:UIButton! = nil
    @IBOutlet var hintLabel:UILabel! = nil
    @IBOutlet var moreButton:UIButton! = nil
    @IBOutlet var previewImageView:UIImageView! = nil
    
    var page:ScanPage? = nil {
        didSet {
            populateWith(page:page)
        }
    }

    var delegate:ReviewViewControllerDelegate? = nil
    
    @IBAction func useButtonTapped() {
        // TODO: get the current image data since it might have been rotated
        delegate?.reviewController(self, didAcceptPage: page!)
    }
    
    @IBAction func rejectButtonTapped() {
        delegate?.reviewController(self, didRejectPage: page!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateWith(page: self.page)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func populateWith(page:ScanPage?) {
        guard let data = page?.imageData,
        let preview = previewImageView,
        let _ = view /* just to make sure the view is loaded */ else { return }
        preview.image = UIImage(data: data)
    }

}
