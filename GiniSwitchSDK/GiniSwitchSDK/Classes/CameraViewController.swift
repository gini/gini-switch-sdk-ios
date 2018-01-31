//
//  CameraViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.05.17.
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
    
    weak var delegate:CameraViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if camera == nil {
            do {
                try camera = Camera()
            } catch let error as CameraError {
                switch error {
                case .notAuthorizedToUseDevice:
                    isCameraAvailable = false
                    addNotAuthorizedView()
                default:
                    isCameraAvailable = false
                }
            } catch _ {
                assertionFailure("Failed to initialize camera")
            }
        }
        
        // Configure preview view
        if let validCamera = camera {
            cameraPreview.session = validCamera.session
            (cameraPreview.layer as! AVCaptureVideoPreviewLayer).videoGravity = AVLayerVideoGravity.resizeAspect
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
            #if DEBUG
                // This will most likely happen when debugging on the Simulator. Just inject
                // a sample document
                if let image = UIImage(named: "sampleDocument",
                                       in: Bundle(identifier: "org.cocoapods.GiniSwitchSDK"),
                                       compatibleWith: nil),
                    let imageData = UIImageJPEGRepresentation(image, 1) {
                    DispatchQueue.main.async {
                        self.delegate?.cameraViewController(controller: self, didCaptureImage: imageData)
                    }
                }
            #endif
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
