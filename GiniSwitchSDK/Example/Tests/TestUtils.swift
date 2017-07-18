//
//  TestUtils.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 09.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import Foundation
import UIKit
@testable import GiniSwitchSDK

func switchStoryboard() -> UIStoryboard? {
    return UIStoryboard.switchStoryboard()
}

func testImageData() -> Data {
    let testImage = UIImage(named: "testDocument")
    return UIImageJPEGRepresentation(testImage!, 0.1)!
}

func testImageScanPage() -> ScanPage {
    return ScanPage(imageData: testImageData())
}
