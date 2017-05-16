//
//  FakeCamera.swift
//  GiniTariffSDK
//
//  Created by Nikola Sobadjiev on 10.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
@testable import GiniTariffSDK

class FakeCamera: Camera {
    
    var isStarted = false
    var hasCaptured = false
    
    override func start() {
        isStarted = true
    }
    
    override func stop() {
        isStarted = false
    }
    
    override func captureStillImage(_ completion: (Data) -> Void) {
        hasCaptured = true
        completion(Data())
    }

}
