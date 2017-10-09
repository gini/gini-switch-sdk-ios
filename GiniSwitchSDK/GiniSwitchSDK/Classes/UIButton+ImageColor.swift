//
//  UIButton+ImageColor.swift
//  GiniSwitchSDK
//
//  Created by Nikola Sobadjiev on 09.10.17.
//

import Foundation

extension UIButton {
    
    var imageColor: UIColor {
        get {
            return tintColor
        }
        set {
            guard let buttonImage = self.image(for: .normal) else {
                    return
            }
            setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .normal)
            tintColor = newValue
        }
    }
    
}
