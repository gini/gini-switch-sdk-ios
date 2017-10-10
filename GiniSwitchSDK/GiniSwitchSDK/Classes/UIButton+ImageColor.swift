//
//  UIButton+ImageColor.swift
//  GiniSwitchSDK
//
//  Created by Nikola Sobadjiev on 09.10.17.
//

import Foundation

extension UIButton {
    
    /// Sets the image tint color for the normal control state
    var imageColor: UIColor {
        get {
            return tintColor
        }
        set {
            setImageColor(newValue, forState: .normal)
        }
    }
    
    func setImageColor(_ color:UIColor, forState buttonState: UIControlState) {
        guard let buttonImage = self.image(for: buttonState) else {
            return
        }
        setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: buttonState)
        tintColor = color
    }
    
}
