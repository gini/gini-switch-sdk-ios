//
//  MultiPageCoordinator.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 16.05.17.
//
//

import UIKit

class MultiPageCoordinator {

    let cameraOptionsController:CameraOptionsViewController
    let cameraController:CameraViewController
    let pageCollectionController:PagesCollectionViewController
    
    init(camera:CameraViewController, cameraOptions:CameraOptionsViewController, pagesCollection:PagesCollectionViewController) {
        cameraOptionsController = cameraOptions
        cameraController = camera
        pageCollectionController = pagesCollection
        
        cameraOptionsController.delegate = self
        cameraController.delegate = self
    }
}

extension MultiPageCoordinator: CameraOptionsViewControllerDelegate {
    
    func cameraController(cameraController:CameraOptionsViewController, didCaptureImageData:Data) {
        self.cameraController.takePicture()
    }
    
    func cameraControllerIsDone(cameraController:CameraOptionsViewController) {
        
    }
}

extension MultiPageCoordinator: CameraViewControllerDelegate {
    
    func cameraViewController(controller:CameraViewController, didCaptureImage data:Data) {
        // create a new scan page
        let newPage = ScanPage(imageData: data, id: nil, status: .taken)
        self.pageCollectionController.pages?.add(element: newPage)
    }
    
    func cameraViewController(controller:CameraViewController, didFailWithError error:Error) {
        
    }
}
