import Foundation
import Logging
import Pulse
import PulseLogHandler

public final class EventLogger {
    
    public static var `default` = EventLogger(category: .default)
    
    private let logger: Logging.Logger
    
    public init(category: String) {
        logger = Logging.Logger(label: category)
    }
    
    public static func setupLgger() {
        LoggingSystem.bootstrap(PersistentLogHandler.init)
        Experimental.URLSessionProxy.shared.isEnabled = true
    }
    
    public func log(
        level: Logger.Level,
        message: String,
        metadata: Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.log(
            level: level,
            Logger.Message(stringLiteral: message),
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    public static func disableRemoteLogger() {
        RemoteLogger.shared.disable()
    }
}

public extension EventLogger {
    func debug(
        _ message: String,
        metadata: Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(level: .debug, message: message, metadata: metadata, file: file, function: function, line: line)
    }

    func error(
        _ message: String,
        metadata: Logger.Metadata? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(level: .error, message: message, metadata: metadata, file: file, function: function, line: line)
    }
}