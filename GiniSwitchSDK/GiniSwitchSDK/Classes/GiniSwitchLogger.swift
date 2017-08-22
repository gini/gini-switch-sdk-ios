//
//  GiniSwitchLogger.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//
//

public enum LogLevel : Int {
    case verbose = 0
    case debug
    case info
    case warn
    case error
}

public protocol GiniSwitchLogger {
    
    func log(level:LogLevel, message:String)
    func logVerbose(message:String)
    func logDebug(message:String)
    func logInfo(message:String)
    func logWarn(message:String)
    func logError(message:String)
    
}

var logger:GiniSwitchLogger = GiniSwitchConsoleLogger()

func Logger() -> GiniSwitchLogger {
    return logger
}
