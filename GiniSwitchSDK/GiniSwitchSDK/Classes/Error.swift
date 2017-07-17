//
//  Error.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 21.06.17.
//
//

/// the domain for all errors that occur in the SDK
let TariffErrorDomain = "net.gini.tariff"

enum TariffErrorCode:Int {
    // low level errors
    case unknown
    case network
    case authentication
    case tokenExpired
    case invalidResponse
    
    // high level error
    case cannotCreateExtractionOrder
    case cannotUploadPage
    case pageAnalysisFailed
    case pageDeleteError
    case pageReplaceError
    case extractionsError
    case pageStatusError
}

extension NSError {
    
    /// Try to initialize an error from an API response
    convenience init?(dictionary:JSONDictionary) {
        if let errorName = dictionary["error"] as? String {
            let errorCode = dictionary["status"] as? Int     // TODO: might become mandatory after implemented in the backend
            let errorDesc = dictionary["error_description"] as? String
            let inAppErrorCode = NSError.tariffErrorCode(apiCode:errorCode ?? 0)
            let userDict = [NSLocalizedDescriptionKey: errorName,
                            NSLocalizedFailureReasonErrorKey: errorDesc ?? ""]
            self.init(domain: TariffErrorDomain, code: inAppErrorCode.rawValue, userInfo: userDict)
        }
        else {
            return nil
        }
    }
    
    convenience init(errorCode:TariffErrorCode, underlyingError:Error? = nil) {
        var userDict:[AnyHashable : Any] = [:]
        if let error = underlyingError {
            userDict[NSUnderlyingErrorKey] = error
        }
        self.init(domain: TariffErrorDomain, code: errorCode.rawValue, userInfo: userDict)
    }
    
    func errorName() -> String? {
        return self.userInfo[NSLocalizedDescriptionKey] as? String
    }
    
    func errorReason() -> String? {
        return self.userInfo[NSLocalizedFailureReasonErrorKey] as? String
    }
    
    func underlyingError() -> Error? {
        return self.userInfo[NSUnderlyingErrorKey] as? Error
    }
    
    /// Translates the error code returned from the server into an error code the app recognizes
    class func tariffErrorCode(apiCode:Int) -> TariffErrorCode {
        let errors:[Int: TariffErrorCode] = [400: .authentication, 401: .tokenExpired]  // TODO: just a sample list
        return errors[apiCode] ?? .unknown
    }
}

extension NSError {
    
    func isRetriableError() -> Bool {
        return isTimeoutError()     // for now only timeouts are retried
    }
    
    func isTimeoutError() -> Bool {
        return code == NSURLErrorTimedOut && domain == NSURLErrorDomain
    }
    
    func isTokenExpiredError() -> Bool {
        return NSError.tariffErrorCode(apiCode: code) == .tokenExpired ||
            errorName() == "invalid_token"      // TODO: don't rely on names - check the code only
    }
}
