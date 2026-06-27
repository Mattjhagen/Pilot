import Foundation

struct AppConfiguration {
    let environment: Environment
    
    enum Environment {
        case development
        case staging
        case production
    }
    
    var isDebugMenuEnabled: Bool {
        environment != .production
    }
    
    static let live = AppConfiguration(environment: _determineEnvironment())
    static let mock = AppConfiguration(environment: .development)
    
    private static func _determineEnvironment() -> Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}
