//
//  CameraViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 09.05.17.
//
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: class {
    
    func cameraViewController(controller:CameraViewController, didCaptureImage data:Data)
    func cameraViewController(controller:CameraViewController, didFailWithError error:Error)
    
}

class CameraViewController: UIViewController {
    
    @IBOutlet var cameraPreview:CameraPreviewView! = nil
    @IBOutlet var unauthorizedView:UIView! = nil
    
    var camera:Camera! = nil
    var isCameraAvailable = true
    
    weak var delegate:CameraViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if camera == nil {
            do {
                try camera = Camera()
            }
            catch let error as CameraError {
                switch error {
                case .notAuthorizedToUseDevice:
                    isCameraAvailable = false
                    addNotAuthorizedView()
                default:
                    break
                }
            }
            catch _ {
                assertionFailure("Failed to initialize camera")
            }
        }
        
        // Configure preview view
        if let validCamera = camera {
            cameraPreview.session = validCamera.session
            (cameraPreview.layer as! AVCaptureVideoPreviewLayer).videoGravity = AVLayerVideoGravityResizeAspect
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera?.start()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        camera?.stop()
    }
    
    public func takePicture() {
        guard isCameraAvailable else {
            // TODO: this will work, but it would be better to be proactive and prevent pictures
            // from being taken
            return
        }
        camera.captureStillImage { (data) in
            self.delegate?.cameraViewController(controller: self, didCaptureImage: data)
        }
    }
    
    fileprivate func addNotAuthorizedView() {
        unauthorizedView.isHidden = false
    }

}
