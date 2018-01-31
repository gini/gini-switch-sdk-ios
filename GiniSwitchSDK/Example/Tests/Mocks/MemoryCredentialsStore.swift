//
//  MemoryCredentialsStore.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 07.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import UIKit
@testable import GiniSwitchSDK

final class MemoryCredentialsStore: CredentialsStore {
    
    var accessToken:String?
    
    var refreshToken:String?
    
    var expirationPeriod:Int?
    
    var user:User?

}
