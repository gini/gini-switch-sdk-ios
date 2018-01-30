//
//  OnboardingPageViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 28.06.17.
//
//

import UIKit

class OnboardingPageViewController: UIViewController {
    
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var textLabel:UILabel?
    
    var page:OnboardingPage = OnboardingPage() {
        didSet {
            image = page.image
            text = page.text
        }
    }
    
    var image:UIImage? = nil {
        didSet {
            imageView?.image = image
        }
    }
    
    var text:String = "" {
        didSet {
            textLabel?.text = text
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView?.image = image
        textLabel?.text = text
    }

}
