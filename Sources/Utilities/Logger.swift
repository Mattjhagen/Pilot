import Foundation
import OSLog

struct PilotLogger {
    private let logger = Logger(subsystem: "com.pilot", category: "Application")
    
    func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }
    
    func warning(_ message: String) {
        logger.warning("⚠️ \(message, privacy: .public)")
    }
    
    func error(_ message: String, error: Error? = nil) {
        if let error = error {
            logger.error("❌ \(message, privacy: .public) - \(error.localizedDescription, privacy: .public)")
        } else {
            logger.error("❌ \(message, privacy: .public)")
        }
    }
    
    static let live = PilotLogger()
    static let mock = PilotLogger()
}
