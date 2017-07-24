//
//  CameraOptionsViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 11.05.17.
//
//

import UIKit

protocol CameraOptionsViewControllerDelegate: class {
    
    func cameraController(cameraController:CameraOptionsViewController, didCaptureImageData:Data)
    func cameraControllerIsDone(cameraController:CameraOptionsViewController)
    
}

class CameraOptionsViewController: UIViewController {
    
    @IBOutlet var captureButton:UIButton! = nil
    @IBOutlet var doneButton:UIButton! = nil
    
    weak var delegate:CameraOptionsViewControllerDelegate? = nil
    
    var textColor:UIColor? {
        didSet {
            setupStyle()
        }
    }
    var doneButtonText:String? {
        didSet {
            setupStyle()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }
    
    fileprivate func setupStyle() {
        if let color = textColor {
            doneButton.setTitleColor(color, for: .normal)
        }
        if let text = doneButtonText {
            doneButton.setTitle(text, for: .normal)
        }
    }

}

// IBActions
extension CameraOptionsViewController {
    
    @IBAction func onCaptureTapped() {
        self.delegate?.cameraController(cameraController: self, didCaptureImageData: Data())
    }
    
    @IBAction func onDoneTapped() {
        self.delegate?.cameraControllerIsDone(cameraController: self)
    }
}
