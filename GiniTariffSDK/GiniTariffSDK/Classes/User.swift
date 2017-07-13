//
//  User.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 30.05.17.
//
//

import UIKit

struct User {

    var email:String? = nil
    var password:String? = nil
    
    init() {
        email = nil
        password = nil
    }
    
    init(email:String, password:String) {
        self.email = email
        self.password = password
    }
    
    init?(_ dictionary:JSONDictionary) {
        guard let pass = dictionary["password"] as? String,
            let mail = dictionary["email"] as? String else {
                return nil
        }
        self.init(email:mail, password:pass)
    }

}
