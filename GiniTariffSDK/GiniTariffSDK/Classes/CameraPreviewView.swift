//
//  CameraPreviewView.swift
//  GiniVision
//
//  Created by Peter Pult on 14/06/16.
//  Copyright © 2016 Gini GmbH. All rights reserved.
//

import UIKit
import AVFoundation

internal class CameraPreviewView: UIView {
    
    let guideLineLength:CGFloat = 20.0
    let guideLineWidth:CGFloat = 3.0
    /// the size of the guides compared to the size of the whole view
    /// 0.9 = 90% of the view
    let guideLineSize:CGFloat = 0.9
    let guideColor = UIColor.red
    
    override class var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.classForCoder()
    }
    
    var session: AVCaptureSession {
        get {
            return (self.layer as! AVCaptureVideoPreviewLayer).session
        }
        set(newSession) {
            (self.layer as! AVCaptureVideoPreviewLayer).session = newSession
        }
    }
    
    override func awakeFromNib() {
        drawGuides()
    }
    
}

extension CameraPreviewView {
    
    fileprivate func drawGuides() {
        // get a size that's a close to guideLineSize as possible, while still respecting the
        // ratio of a standard A4 piece of paper
        let guideSize = biggestA4SizeRect()
        let rectLayer = CAShapeLayer()
        rectLayer.frame = guideSize
        rectLayer.position = center
        let path = guidePath(size:guideSize.size)
        rectLayer.path = path
        styleLayer(rectLayer)
        layer.addSublayer(rectLayer)
    }
    
    fileprivate func biggestA4SizeRect() -> CGRect {
        let a4Ratio:CGFloat = 21.0 / 31.0
        let wholeFrame = bounds
        let maxWidth = wholeFrame.width * guideLineSize
        let maxHeight = wholeFrame.height * guideLineSize
        if maxHeight > maxWidth {
            return CGRect(x: 0, y: 0, width: maxHeight * a4Ratio, height: maxHeight)
        }
        else {
            return CGRect(x: 0, y: 0, width: maxWidth, height: maxWidth / a4Ratio)
        }
    }
    
    fileprivate func guidePath(size:CGSize) -> CGPath {
        let guidePath = UIBezierPath()
        
        guidePath.move(to: CGPoint(x: 0.0, y: guideLineLength))
        guidePath.addLine(to: CGPoint(x: 0.0, y: 0.0))
        guidePath.addLine(to: CGPoint(x: guideLineLength, y: 0.0))
        
        guidePath.move(to: CGPoint(x: size.width - guideLineLength, y: 0.0))
        guidePath.addLine(to: CGPoint(x: size.width, y: 0.0))
        guidePath.addLine(to: CGPoint(x: size.width, y: guideLineLength))
        
        guidePath.move(to: CGPoint(x: size.width, y: size.height - guideLineLength))
        guidePath.addLine(to: CGPoint(x: size.width, y: size.height))
        guidePath.addLine(to: CGPoint(x: size.width - guideLineLength, y: size.height))
        
        guidePath.move(to: CGPoint(x: guideLineLength, y: size.height))
        guidePath.addLine(to: CGPoint(x: 0, y: size.height))
        guidePath.addLine(to: CGPoint(x: 0, y: size.height - guideLineLength))
        return guidePath.cgPath
    }
    
    fileprivate func styleLayer(_ layer:CAShapeLayer) {
        layer.strokeColor = guideColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = guideLineWidth
    }
    
}
