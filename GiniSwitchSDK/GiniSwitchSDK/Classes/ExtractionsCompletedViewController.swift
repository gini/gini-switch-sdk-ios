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
    
    var textSize:CGFloat? = nil {
        didSet {
            setupSize(textSize)
        }
    }
    
    var textColor:UIColor? = nil {
        didSet {
            setupTextColor(textColor)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage(image)
        setupText(text)
        setupSize(textSize)
        setupTextColor(textColor)
    }
    
    fileprivate func setupText(_ text:String?) {
        guard text?.isEmpty == false,
            let label = textLabel else {
                return
        }
        label.text = text
    }
    
    fileprivate func setupImage(_ image:UIImage?) {
        guard image != nil,
        let view = imageView else {
            return
        }
        view.image = image
    }
    
    fileprivate func setupSize(_ size:CGFloat?) {
        if let label = textLabel,
            let size = textSize {
            label.font = UIFont.systemFont(ofSize: size)
        }
    }
    
    fileprivate func setupTextColor(_ color:UIColor?) {
        if let label = textLabel,
            let color = color {
            label.textColor = color
        }
    }

}
