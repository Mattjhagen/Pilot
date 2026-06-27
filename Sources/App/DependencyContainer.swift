import Foundation
import Observation

@Observable
final class DependencyContainer {
    static let shared = DependencyContainer()
    
    let configuration: AppConfiguration
    let logger: PilotLogger
    let homeService: HomeService
    let copilotService: CopilotService
    let moneyService: MoneyService
    let trustService: TrustService
    let automationsStorage: AutomationsStorageService
    let automationRunner: AutomationRunner
    let lendingService: LendingService
    let lendingManager: LendingManager
    
    private init(
        configuration: AppConfiguration = .live,
        logger: PilotLogger = .live,
        homeService: HomeService = HomeMockService(),
        copilotService: CopilotService = CopilotMockService(),
        moneyService: MoneyService = MoneyMockService(),
        trustService: TrustService = TrustMockService(),
        automationsStorage: AutomationsStorageService = InMemoryAutomationsStorageService(),
        automationRunner: AutomationRunner = AutomationMockRunner(),
        lendingService: LendingService = LendingMockService(),
        lendingManager: LendingManager = LendingManager(lendingService: LendingMockService(), trustService: TrustMockService(), moneyService: MoneyMockService())
    ) {
        self.configuration = configuration
        self.logger = logger
        self.homeService = homeService
        self.copilotService = copilotService
        self.moneyService = moneyService
        self.trustService = trustService
        self.automationsStorage = automationsStorage
        self.automationRunner = automationRunner
        self.lendingService = lendingService
        self.lendingManager = lendingManager
    }
}
