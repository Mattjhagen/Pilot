import Foundation
import Observation

@Observable
final class DependencyContainer {
    static let shared = DependencyContainer()
    
    let configuration: AppConfiguration
    let logger: PilotLogger
    
    private init(
        configuration: AppConfiguration = .live,
        logger: PilotLogger = .live
    ) {
        self.configuration = configuration
        self.logger = logger
    }
}
