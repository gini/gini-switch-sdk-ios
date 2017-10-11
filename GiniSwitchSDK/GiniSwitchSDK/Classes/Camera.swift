//
//  Camera.swift
//  GiniVision
//
//  Created by Peter Pult on 15/02/16.
//  Copyright © 2016 Gini GmbH. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum CameraError: Int, Error {
    
    /// Unknown error during camera use.
    case unknown = 0
    
    /// Camera can not be loaded because the user has denied authorization in the past.
    case notAuthorizedToUseDevice
    
    /// No valid input device could be found for capturing.
    case noInputDevice
    
    /// Capturing could not be completed.
    case captureFailed
    
}

internal class Camera {
    
    // Session management
    var session: AVCaptureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput?
    var stillImageOutput: AVCaptureStillImageOutput?
    fileprivate lazy var sessionQueue:DispatchQueue = DispatchQueue(label: "session queue", attributes: [])
    
    init() throws {
        try setupSession()
    }
    
    // MARK: Public methods
    func start() {
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    func stop() {
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    func focusWithMode(_ focusMode: AVCaptureDevice.FocusMode, exposeWithMode exposureMode: AVCaptureDevice.ExposureMode, atDevicePoint point: CGPoint, monitorSubjectAreaChange: Bool) {
        sessionQueue.async {
            guard let device = self.videoDeviceInput?.device else { return }
            guard case .some = try? device.lockForConfiguration() else { return print("Could not lock device for configuration") }
            
            if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
                device.focusPointOfInterest = point
                device.focusMode = focusMode
            }
            
            if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
                device.exposurePointOfInterest = point
                device.exposureMode = exposureMode
            }
            
            device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
            device.unlockForConfiguration()
        }
    }
    
    func captureStillImage(_ completion: @escaping (Data) -> Void) {
        sessionQueue.async {
            // Connection will be `nil` when there is no valid input device; for example on iOS simulator
            guard let connection = self.stillImageOutput?.connection(with: AVMediaType.video) else {
                return completion(Data())   // TODO return an error
            }
            self.videoDeviceInput?.device.setFlashModeSecurely(.on)
            self.stillImageOutput?.captureStillImageAsynchronously(from: connection) { (imageDataSampleBuffer: CMSampleBuffer?, error: Error?) -> Void in
                guard error == nil else { return completion(Data()) }  // TODO return an error
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                guard let data = imageData else {
                    return completion(Data())   // TODO return an error
                }
                return completion(data)
            }
        }
    }
    
    class func saveImageFromData(_ data: Data) {
        PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
            guard status == .authorized else { return print("No access to photo library granted") }
            
            // Check for iOS to make sure `PHAssetCreationRequest` class is available
            if #available(iOS 9.0, *) {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
                    },
                    completionHandler: { (success: Bool, error: Error?) -> Void in
                        guard success else { return print("Could not save image to photo library") }
                })
            } else {
                // TODO: Add option for older iOS
            }
        })
    }
    
    func setupSession() throws {
        // Setup is not performed asynchronously because of KVOs
        func deviceWithMediaType(_ mediaType: String, preferringPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
            let devices = AVCaptureDevice.devices(for: AVMediaType(rawValue: mediaType)).filter { $0.position == position }
            guard let device = devices.first else { return nil }
            return device
        }
        
        let videoDevice = deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .back)
        guard let device = videoDevice else {
            return
        }
        do {
            self.videoDeviceInput = try AVCaptureDeviceInput(device: device)
        } catch let error as NSError {
            print("Could not create video device input \(error)")
            if error.code == AVError.Code.applicationIsNotAuthorizedToUseDevice.rawValue {
                throw CameraError.notAuthorizedToUseDevice
            } else {
                throw CameraError.unknown
            }
        }
        
        self.session.beginConfiguration()
        // Specify that we are capturing a photo, this will reset the format to be 4:3
        self.session.sessionPreset = AVCaptureSession.Preset.photo
        if self.session.canAddInput(self.videoDeviceInput!) {
            self.session.addInput(self.videoDeviceInput!)
        } else {
            print("Could not add video device input to the session")
        }
        
        let output = AVCaptureStillImageOutput()
        if self.session.canAddOutput(output) {
            output.outputSettings = [ AVVideoCodecKey: AVVideoCodecJPEG ];
            self.session.addOutput(output)
            self.stillImageOutput = output
        } else {
            print("Could not add still image output to the session")
        }
        
        self.session.commitConfiguration()
    }
}

// TODO: is this the best way?
internal extension AVCaptureDevice {
    
    func setFlashModeSecurely(_ mode: AVCaptureDevice.FlashMode) {
        guard hasFlash && isFlashModeSupported(mode) else { return }
        guard case .some = try? lockForConfiguration() else { return print("Could not lock device for configuration") }
        flashMode = mode
        unlockForConfiguration()
    }
    
}
