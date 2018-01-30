//
//  Authenticator.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 01.06.17.
//
//

import UIKit

enum AuthenticatorState {
    case none
    case clientToken
    case userCredentials
    case userToken
}

typealias AuthenticatorSuccessCallback = () -> Void
typealias AuthenticatorErrorCallback = (_ error:Error) -> Void

final class Authenticator {
    
    // urls
    let baseUrl = URL(string:"https://user.gini.net")!
    let authUrlExtension = "/oauth/token"
    let userLoginUrlExtension = "/oauth/token?grant_type=password"
    let createUserUrlExtension = "/api/users"
    
    // url parameters
    let loginTypeParameter = "grant_type"
    let loginTypeClientSecret = "client_credentials"
    let loginTypePassword = "password"
    
    // input
    var clientId:String?
    var clientSecret:String?
    var clientDomain:String?
    var clientToken:String?
    var credentials:CredentialsStore
    var completionCallback:AuthenticatorSuccessCallback?
    var failureCallback:AuthenticatorErrorCallback?
    
    var authState = AuthenticatorState.none
    var webService:WebService = UrlSessionWebService()     // should be a var to allow injection
    var userManager = UserManager()

    var createClientToken:Resource<Token> {
        assert(clientId != nil, "Attempted to authenticate without a client ID")
        assert(clientSecret != nil, "Attempted to authenticate without a client secret")
        var fullUrl = baseUrl.appendingPathComponent(authUrlExtension)
        fullUrl = fullUrl.appendingQueryParameter(name: loginTypeParameter, value: loginTypeClientSecret)!

        var authHeaders = basicAuthHeadersDictFor(user: clientId!, pass: clientSecret!)
        authHeaders["Accept"] = "application/json"      // TODO: don't hardcode
        return Resource<Token>(url: fullUrl, headers: authHeaders, method: .GET, body: nil)
    }
    
    var userLogin:Resource<Token> {
        let user = userManager.user
        assert(user != nil, "Attempting to login without user credentials")
        var fullUrl = baseUrl.appendingPathComponent(authUrlExtension)
        fullUrl = fullUrl.appendingQueryParameter(name: loginTypeParameter, value: loginTypePassword)!
        let authHeaders = basicAuthHeadersDictFor(user: clientId!, pass: clientSecret!)
        let payload = userCredentialsPayloadFor(user:user!)
        return Resource<Token>(url: fullUrl, headers: authHeaders, method: .POST, body: payload)
    }
    
    var createUser:Resource<Bool> {
        assert(clientToken != nil, "Attempting to create user without a client token")
        let user = userManager.user
        assert(user != nil, "Attempting to create user without credentials")
        let fullUrl = baseUrl.appendingPathComponent(createUserUrlExtension)
        let authHeaders = Token.bearerAuthHeadersDictWith(token:clientToken!)
        let body = userCredentialsJsonData(for: user!)
        return Resource<Bool>(url: fullUrl, headers: authHeaders, method: .POST, body: body)
    }
    
    var isLoggedIn:Bool {
        return (authState == .userToken)
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
        if credentials.accessToken?.isEmpty == false {
            authState = .userToken
            return
        }
        if credentials.user != nil {
            authState = .userCredentials
            return
        } else {
            
        }
        // No check for a client token. It is not saved. If the client previously had one,
        // a new one will be requested nevertheless
        authState = .none
    }
    
    public func authenticate() {
        proceedWithAuthentication()
    }
    
    /// Will go through the whole authentication process even if it has pre-cached credentials
    public func reauthenticate() {
        // TODO: maybe just delete all credentials and relogin
        authState = .userCredentials
        proceedWithAuthentication()
    }
    
    public func authenticate(success:@escaping AuthenticatorSuccessCallback,
                             failure:@escaping AuthenticatorErrorCallback) {
        completionCallback = success
        failureCallback = failure
        authenticate()
    }
    
    func proceedWithAuthentication() {
        switch authState {
        case .none:
            webService.load(resource: createClientToken, completion: { [weak self] (token, error) in
                if let error = error {
                    self?.failureCallback?(error)
                } else {
                    self?.authState = .clientToken
                    self?.clientToken = token?.accessToken
                    self?.proceedWithAuthentication()
                }
            })
        case .clientToken:
            webService.load(resource: createUser, completion: { [weak self] (_, error) in
                if let error = error {
                    self?.failureCallback?(error)
                } else {
                    self?.authState = .userCredentials
                    // self?.user - user should already be there - credentials are client generated
                    self?.proceedWithAuthentication()
                }
            })
        case .userCredentials:
            webService.load(resource: userLogin, completion: { [weak self] (token, error) in
                if let error = error {
                    if (error as NSError).isInvalidUserError() {
                        self?.authState = .none
                        self?.credentials.user = nil
                        self?.credentials.accessToken = nil
                        self?.proceedWithAuthentication()
                    } else {
                        self?.failureCallback?(error)
                    }
                } else {
                    self?.authState = .userToken
                    self?.credentials.accessToken = token?.accessToken
                    self?.proceedWithAuthentication()
                }
            })
        case .userToken:
            // already logged in
            // if the token has expired, the next request is going to fail with an authentication
            // error and login will be done again
            completionCallback?()
        }
    }
}

// Basic authentication
extension Authenticator {
    
    func basicAuthHeaderFor(user:String, pass:String) -> String {
        let credentials = "\(user):\(pass)"
        let credData = credentials.data(using: .utf8)
        return "Basic \(credData?.base64EncodedString() ?? "")"
    }
    
    func basicAuthHeadersDictFor(user:String, pass:String) -> [String: String] {
        let basicAuth = basicAuthHeaderFor(user: clientId!, pass: clientSecret!)
        return ["Authorization": basicAuth]
    }

}

// User
extension Authenticator {
    
    func userCredentialsPayloadFor(user:User) -> Data {
        let stringValue = "username=\(user.email ?? "")&password=\(user.password ?? "")"
        return stringValue.data(using: .utf8) ?? Data()
    }
    
    func userCredentialsJsonData(for user:User) -> Data {
        let userDict = ["email": user.email, "password": user.password]
        let jsonData = try? JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted)
        return jsonData ?? Data()
    }
}
