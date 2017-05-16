//
//  TestUtils.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 09.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

func tariffStoryboard() -> UIStoryboard? {
    return UIStoryboard(name: "Tariff", bundle: Bundle(identifier: "org.cocoapods.GiniTariffSDK"))
}

func testImageData() -> Data {
    let testImage = UIImage(named: "testDocument")
    return UIImageJPEGRepresentation(testImage!, 0.1)!
}
