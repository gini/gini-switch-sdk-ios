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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
