//
//  MemoryCredentialsStore.swift
//  GiniTariffSDK
//
//  Created by Gini GmbH on 07.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
@testable import GiniTariffSDK

class MemoryCredentialsStore: CredentialsStore {
    
    var accessToken:String?
    
    var refreshToken:String?
    
    var expirationPeriod:Int?
    
    var user:User?

}
