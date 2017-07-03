//
//  ExtractionsCompletedViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 03.07.17.
//
//

import UIKit

class ExtractionsCompletedViewController: UIViewController {
    
    @IBOutlet var imageView:UIImageView! = nil
    @IBOutlet var textLabel:UILabel! = nil
    
    var image:UIImage? = nil {
        didSet {
            guard imageView != nil else {
                return
            }
            imageView.image = image
        }
    }
    
    var text:String? = nil {
        didSet {
           setupText(text)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        setupText(text)
    }
    
    fileprivate func setupText(_ text:String?) {
        guard text?.isEmpty == false else {
            return
        }
        textLabel.text = text
    }

}
