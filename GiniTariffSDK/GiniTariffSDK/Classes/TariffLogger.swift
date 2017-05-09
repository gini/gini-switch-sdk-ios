//
//  TariffLogger.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 08.05.17.
//
//

enum LogLevel : Int {
    case verbose = 0
    case debug
    case info
    case warn
    case error
}

protocol TariffLogger {
    
    func log(level:LogLevel, message:String)
    func logVerbose(message:String)
    func logDebug(message:String)
    func logInfo(message:String)
    func logWarn(message:String)
    func logError(message:String)
    
}
