//
//  DashOutlineLayer.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 27.06.17.
//
//

import UIKit

extension CALayer {

    static func dashOutlineLayer(frame:CGRect, color:UIColor, lineWidth:CGFloat = 2, dashLength:NSNumber = 4) -> CALayer {
        let layer = CAShapeLayer()
        layer.frame = frame
        layer.path = CGPath(rect: frame, transform: nil)
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = lineWidth
        layer.lineDashPattern = [dashLength, dashLength]
        return layer
    }
}
