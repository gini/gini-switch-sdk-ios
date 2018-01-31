//
//  NoOpWebService.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 07.06.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import UIKit
@testable import GiniSwitchSDK

final class NoOpWebService: WebService {
    
    var resource:AnyObject? = nil       // TODO: use Resource as data type
    
    func load<A>(resource: Resource<A>, completion: @escaping (A?, Error?) -> ()) {
        self.resource = resource as AnyObject 
    }

}
