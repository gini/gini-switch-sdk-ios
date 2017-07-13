//
//  ExtractionsCompletedViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 03.07.17.
//
//

import UIKit

class ExtractionsCompletedViewController: UIViewController {
    
    @IBOutlet var imageView:UIImageView! = nil
    @IBOutlet var textLabel:UILabel! = nil
    
    var image:UIImage? = nil {
        didSet {
            setupImage(image)
        }
    }
    
    var text:String? = nil {
        didSet {
           setupText(text)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage(image)
        setupText(text)
    }
    
    fileprivate func setupText(_ text:String?) {
        guard text?.isEmpty == false else {
            return
        }
        textLabel.text = text
    }
    
    fileprivate func setupImage(_ image:UIImage?) {
        guard image != nil else {
            return
        }
        imageView.image = image
    }

}
