//
//  UIStoryboard+Tariff.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 17.05.17.
//
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func switchStoryboard() -> UIStoryboard? {
        return UIStoryboard(name: "GiniSwitch", bundle: Bundle(identifier: "org.cocoapods.GiniTariffSDK"))
    }
    
}
