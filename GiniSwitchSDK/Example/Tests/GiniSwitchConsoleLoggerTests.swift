//
//  GiniSwitchConsoleLoggerTests.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 08.05.17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniSwitchSDK

final class GiniSwitchConsoleLoggerTests: XCTestCase {
    
    let logger = GiniSwitchConsoleLogger()
    
    override func setUp() {
        logger.minLogLevel = .verbose
    }
    
    func testLoggingMessage() {
        let message = logger.fullLogMessage(level: .debug, message: "Test")
        XCTAssertEqual(message, "[Debug] Test", "The complete log message should have a log level prefix")
    }
    
    func testVerboseLogging() {
        let message = logger.fullLogMessage(level: .verbose, message: "Test")
        XCTAssertEqual(message, "[Verbose] Test", "Incorrect prefix for Verbose logs")
    }
    
    func testDebugLogging() {
        let message = logger.fullLogMessage(level: .debug, message: "Test")
        XCTAssertEqual(message, "[Debug] Test", "Incorrect prefix for Debug logs")
    }
    
    func testInfoLogging() {
        let message = logger.fullLogMessage(level: .info, message: "Test")
        XCTAssertEqual(message, "[Info] Test", "Incorrect prefix for Info logs")
    }
    
    func testWarningLogging() {
        let message = logger.fullLogMessage(level: .warn, message: "Test")
        XCTAssertEqual(message, "[Warn] Test", "Incorrect prefix for Warning logs")
    }
    
    func testErrorLogging() {
        let message = logger.fullLogMessage(level: .error, message: "Test")
        XCTAssertEqual(message, "[Err] Test", "Incorrect prefix for Error logs")
    }
    
    func testMinLogLevelFiltering() {
        logger.minLogLevel = .warn
        XCTAssertTrue(logger.shouldLog(level: .info) == false, "Shouldn't log message if the log level is below the min")
    }
    
    func testMinLogLevelLettingThrough() {
        logger.minLogLevel = .debug
        XCTAssertTrue(logger.shouldLog(level: .info) == true, "Should log message if the log level is above the min")
    }
    
    func testMinLogLevelEquality() {
        logger.minLogLevel = .warn
        XCTAssertTrue(logger.shouldLog(level: .warn) == true, "Should log message if the log level is equal to warn")
    }
    
}
