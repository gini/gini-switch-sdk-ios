//
//  GiniSwitchConsoleLogger.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

final class GiniSwitchConsoleLogger: GiniSwitchLogger {
    
    var minLogLevel = LogLevel.info
    
    func log(level:LogLevel, message:String) {
        log(fullMessage: fullLogMessage(level: level, message: message))
    }
    
    func logVerbose(message:String) {
        log(level: .verbose, message: message)
    }
    
    func logDebug(message:String) {
        log(level: .debug, message: message)
    }
    
    func logInfo(message:String) {
        log(level: .info, message: message)
    }
    
    func logWarn(message:String) {
        log(level: .warn, message: message)
    }
    
    func logError(message:String) {
        log(level: .error, message: message)
    }
    
    func fullLogMessage(level:LogLevel, message:String) -> String {
        return "\(prefixFor(logLevel: level)) \(message)"
    }
    
    func log(fullMessage:String) {
        print(fullMessage)
    }
    
    func shouldLog(level:LogLevel) -> Bool {
        return level.rawValue >= minLogLevel.rawValue
    }

}

extension GiniSwitchConsoleLogger {
    
    func prefixFor(logLevel level:LogLevel) -> String {
        switch level {
        case .verbose:
            return "[Verbose]"
        case .debug:
            return "[Debug]"
        case .info:
            return "[Info]"
        case .warn:
            return "[Warn]"
        case .error:
            return "[Err]"
        }
    }
}
