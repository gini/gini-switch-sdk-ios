//
//  DashOutlineLayer.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 27.06.17.
//
//

import UIKit

extension CALayer {

    static func dashedRectangleLayer(frame:CGRect, color:UIColor) -> CALayer {
        let layer = CAShapeLayer()
        layer.frame = frame
        layer.path = CGPath(rect: frame, transform: nil)
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3.0
        layer.lineDashPattern = [5, 5]
        return layer
    }
}
