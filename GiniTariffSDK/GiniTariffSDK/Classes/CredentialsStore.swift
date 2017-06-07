//
//  CredentialsStore.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 31.05.17.
//
//

import UIKit

protocol CredentialsStore {
    
    var accessToken:String? {get set}
    
    var refreshToken:String? {get set}
    
    var expirationPeriod:Int? {get set}
    
    var user:User? {get set}
}

class KeychainCredentialsStore : CredentialsStore {
    
    let accessTokenService = "AccessToken"
    let refreshTokenService = "RefreshToken"
    let expirationService = "TokenExpiration"
    let userService = "UserCredentials"
    let tokenAccountField = "bearerToken"
    
    
    var accessToken:String? {
        set {
            // TODO: if nil is set, delete the token?
            // TODO: look at the returned value
            _ = save(service: accessTokenService, userName: tokenAccountField, secret: newValue ?? "")
        }
        get {
            return load(service: accessTokenService, accountName: tokenAccountField)?.secret
        }
    }
    
    var refreshToken:String? {
        set {
            // TODO: if nil is set, delete the token?
            // TODO: look at the returned value
            _ = save(service: refreshTokenService, userName: tokenAccountField, secret: newValue ?? "")
        }
        get {
            return load(service: refreshTokenService, accountName: tokenAccountField)?.secret
        }
    }
    
    var expirationPeriod:Int? {
        set {
            // TODO: if nil is set, delete the token?
            // TODO: look at the returned value
            _ = save(service: expirationService, userName: tokenAccountField, secret: "\(newValue ?? 0)")
        }
        get {
            guard let expirationString = load(service: expirationService, accountName: tokenAccountField)?.secret else {
                return nil
            }
            return Int(expirationString)
        }
    }
    
    var user:User? {
        set {
            guard let email = newValue?.email,
                let password = newValue?.password else {
                    return
            }
            _ = save(service: userService, userName: email, secret: password)
        }
        get {
            if let (username, pass) = load(service: userService),
                let user = username {
                return User(email: user, password: pass)
            }
            return nil
        }
    }

}

extension CredentialsStore {
    
    func save(service: String, userName: String, secret: String) -> Bool {
        guard let dataFromString = secret.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            // TODO: this is probably a serious error, but not a fatal one
            return false
        }
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPassword, service, dataFromString], forKeys: [kSecClass as NSString, kSecAttrService as NSString, kSecValueData as NSString])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Note that it was important to delete the old entries BEFORE specifying the user name.
        // Otherwise, if a user with a different name is saved, the old one will remain in the keychain
        keychainQuery[kSecAttrAccount as NSString] = userName
        
        // Add the new keychain item
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        return (status == errSecSuccess)
    }
    
    func load(service: String, accountName:String? = nil) -> (accountName:String?, secret:String)? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPassword, service, kCFBooleanTrue, kCFBooleanTrue, kSecMatchLimitOne], forKeys: [kSecClass as NSString, kSecAttrService as NSString, kSecReturnAttributes as NSString, kSecReturnData as NSString, kSecMatchLimit as NSString])
        if let name = accountName {
            keychainQuery[kSecAttrAccount as NSString] = name
        }
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(keychainQuery, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            if let result = result as? NSDictionary {
                let account = result[kSecAttrAccount] as? String
                if let secretData = result[kSecValueData] as? Data,
                    let string = NSString(data: secretData, encoding: String.Encoding.utf8.rawValue) as String? {
                    return (accountName: account, secret: string)
                }
            }
        }
        return nil
    }
    
}