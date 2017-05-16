//
//  CameraOptionsViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 11.05.17.
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
