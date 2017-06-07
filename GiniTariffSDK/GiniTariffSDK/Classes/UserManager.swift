//
//  UserManager.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 31.05.17.
//
//

import UIKit

struct UserManager {

    var clientId:String? = nil
    var clientSecret:String? = nil
    var clientDomain:String? = nil
    var credentials = KeychainCredentialsStore()
    
    init() {
        self.init(clientId: nil, clientSecret: nil, clientDomain: nil)
    }
    
    init(clientId:String?, clientSecret:String?, clientDomain:String?) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.clientDomain = clientDomain
    }
    
    var user:User? {
        // check if there already is a user
        if let storedUser = credentials.user {
            return storedUser
        }
        
        // generate a new one, if there is no user
        return createNewUser()
    }
    
    private func createNewUser() -> User {
        assert((clientDomain != nil), "UserManager needs to have a client domain")
        let username = generateEmail(with: clientDomain!)
        let password = generatePassword()
        return User(email:username, password: password)
    }
}

extension UserManager {
    
    func generateEmail(with domain:String) -> String {
        let uid = UUID().uuidString
        return "\(uid)@\(domain)"
    }
    
    func generatePassword() -> String {
        return UUID().uuidString
    }
}
