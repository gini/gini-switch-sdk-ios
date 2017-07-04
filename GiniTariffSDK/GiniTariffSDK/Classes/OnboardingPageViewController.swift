//
//  OnboardingPageViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 28.06.17.
//
//

import UIKit

class OnboardingPageViewController: UIViewController {
    
    @IBOutlet var imageView:UIImageView? = nil
    @IBOutlet var textLabel:UILabel? = nil
    
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
