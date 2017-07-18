//
//  FakeCamera.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 10.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import UIKit
@testable import GiniSwitchSDK

class FakeCamera: Camera {
    
    var isStarted = false
    var hasCaptured = false
    var hardCodedImageData:Data? = nil
    
    override func setupSession() throws {
        
    }
    
    override func start() {
        isStarted = true
    }
    
    override func stop() {
        isStarted = false
    }
    
    override func captureStillImage(_ completion: @escaping (Data) -> Void) {
        hasCaptured = true
        completion(hardCodedImageData ?? Data())
    }

}
