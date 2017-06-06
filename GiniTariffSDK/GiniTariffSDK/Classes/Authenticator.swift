//
//  Authenticator.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 01.06.17.
//
//

import UIKit

enum AuthenticatorState {
    case none
    case clientToken
    case userCredentials
    case userToken
}

class Authenticator {
    
    let baseUrl = "https://user.gini.net"
    let clientTokenUrlExtension = "/oauth/token?grant_type=client_credentials"
    let userLoginUrlExtension = "/oauth/token?grant_type=password"
    let createUserUrlExtension = "/api/users"
    
    // input
    var clientId:String? = nil
    var clientSecret:String? = nil
    var clientDomain:String? = nil
    var user:User? = nil
    var clientToken:String? = nil
    var userToken:String? = nil
    var credentials:CredentialsStore
    
    var authState = AuthenticatorState.none
    let webService = WebService()
    var userManager = UserManager()

    var createClientToken:Resource<Token> {
        assert(clientId != nil, "Attempted to authenticate without a client ID")
        assert(clientSecret != nil, "Attempted to authenticate without a client secret")
        let fullUrlString = "\(baseUrl)\(clientTokenUrlExtension)"
        let fullUrl = URL(string: fullUrlString)!
        let authHeaders = basicAuthHeadersDictFor(user: clientId!, pass: clientSecret!)
        return Resource<Token>(url: fullUrl, headers: authHeaders, method: "GET", body: nil, parseJSON: { json in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return Token(dictionary)
        })
    }
    
    var userLogin:Resource<Token> {
        assert(user != nil, "Attempting to login without user credentials")
        let fullUrlString = "\(baseUrl)\(userLoginUrlExtension)"
        let fullUrl = URL(string: fullUrlString)!
        let authHeaders = basicAuthHeadersDictFor(user: clientId!, pass: clientSecret!)
        let payload = userCredentialsPayloadFor(user:user!)
        return Resource<Token>(url: fullUrl, headers: authHeaders, method: "POST", body: payload, parseJSON: { json in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return Token(dictionary)
        })
    }
    
    var createUser:Resource<Bool> {
        assert(clientToken != nil, "Attempting to create user without a client token")
        user = userManager.user
        assert(user != nil, "Attempting to create user without credentials")
        let fullUrlString = "\(baseUrl)\(createUserUrlExtension)"
        let fullUrl = URL(string: fullUrlString)!
        let authHeaders = bearerAuthHeadersDictWith(token: clientToken!)
        user = userManager.user
        let body = userCredentialsJsonString(for: user!)
        return Resource<Bool>(url: fullUrl, headers: authHeaders, method: "POST", body: body, parseJSON: { json in
            guard let _ = json as? JSONDictionary else { return nil }
            // TODO: check for errors
            return true
        })
    }
    
    init(credentials:CredentialsStore) {
        self.credentials = credentials
        importCredentials()
    }
    
    convenience init(clientId:String, secret:String, domain: String, credentials:CredentialsStore) {
        self.init(credentials: credentials)
        self.clientId = clientId
        self.clientSecret = secret
        self.clientDomain = domain
        self.userManager = UserManager(clientId: clientId, clientSecret: clientSecret, clientDomain: domain)
    }
    
    func importCredentials() {
        userToken = credentials.accessToken
        if userToken?.isEmpty != true {
            authState = .userToken
            return
        }
        user = credentials.user
        if user != nil {
            authState = .userCredentials
            return
        }
        else {
            
        }
        // No check for a client token. It is not saved. If the client previously had one,
        // a new one will be requested nevertheless
        authState = .none
    }
    
    func saveCredentials() {
        // the initial, client token, is not saved. If the login is interrupted at that stage,
        // a new client token will be generated next time
        credentials.accessToken = userToken
        credentials.user = user
    }
    
    public func authenticate() {
        proceedWithAuthentication()
    }
    
    func proceedWithAuthentication() {
        switch authState {
        case .none:
            webService.load(resource: createClientToken, completion: { [weak self] (token) in
                self?.authState = .clientToken
                self?.clientToken = token?.accessToken
                self?.proceedWithAuthentication()
            })
        case .clientToken:
            webService.load(resource: createUser, completion: { [weak self] (isCreated) in
                self?.authState = .userCredentials
                // self?.user - user should already be there - credentials are client generated
                self?.proceedWithAuthentication()
            })
        case .userCredentials:
            webService.load(resource: userLogin, completion: { [weak self] (token) in
                self?.authState = .userToken
                self?.userToken = token?.accessToken
                self?.proceedWithAuthentication()
            })
        case .userToken:
            // already logged in
            // if the token has expired, the next request is going to fail with an authentication
            // error and login will be done again
            break
        }
        saveCredentials()
    }
}

// Basic authentication
extension Authenticator {
    
    func basicAuthHeaderFor(user:String, pass:String) -> String {
        let credentials = "\(user):\(pass)"
        let credData = credentials.data(using: .utf8)
        // TODO: if credData?.base64EncodedString() is nil, authentication would be impossible
        // How can this case be handled
        return "Basic \(credData?.base64EncodedString() ?? "")"
    }
    
    func basicAuthHeadersDictFor(user:String, pass:String) -> [String: String] {
        let basicAuth = basicAuthHeaderFor(user: clientId!, pass: clientSecret!)
        return ["Authorization": basicAuth]
    }

}

// Bearer tokens
extension Authenticator {
    
    func bearerAuthHeaderWith(token:String) -> String {
        return "Bearer \(token)"
    }
    
    func bearerAuthHeadersDictWith(token:String) -> [String: String] {
        return ["Authorization": bearerAuthHeaderWith(token: token), "Content-Type": "application/json"]
    }
}

// User
extension Authenticator {
    
    func userCredentialsPayloadFor(user:User) -> String {
        return "username=\(user.email ?? "")&password=\(user.password ?? "")"
    }
    
    func userCredentialsJsonString(for user:User) -> String {
        let userDict = ["email": user.email, "password": user.password]
        let jsonData = try? JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted)
        return String(data: jsonData ?? Data(), encoding: .utf8)!
    }
}
