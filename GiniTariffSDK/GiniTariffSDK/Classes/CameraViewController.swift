//
//  CameraViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 09.05.17.
//
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate {
    
    func cameraViewController(controller:CameraViewController, didCaptureImage data:Data)
    func cameraViewController(controller:CameraViewController, didFailWithError error:Error)
    
}

class CameraViewController: UIViewController {
    
    @IBOutlet var cameraPreview:CameraPreviewView! = nil
    
    var camera:Camera! = nil
    
    var delegate:CameraViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if camera == nil {
            do {
                try camera = Camera()
            }
                // TODO: handle CameraError
                //        catch let error as CameraError {
                //            switch error {
                //            case .notAuthorizedToUseDevice:
                //                addNotAuthorizedView()
                //            default:
                //                if GiniConfiguration.DEBUG { cameraState = .valid; addDefaultImage() }
                //            }
                //            failure(error)
                //        }
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
        camera.captureStillImage { (data) in
            self.delegate?.cameraViewController(controller: self, didCaptureImage: data)
        }
    }

}
