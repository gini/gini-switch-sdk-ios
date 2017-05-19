//
//  UIStoryboard+Tariff.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 17.05.17.
//
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func tariffStoryboard() -> UIStoryboard? {
        return UIStoryboard(name: "Tariff", bundle: Bundle(identifier: "org.cocoapods.GiniTariffSDK"))
    }
    
}
