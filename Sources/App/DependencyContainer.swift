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
    let aggregationService: AggregationService
    let integrationManager: IntegrationManager
    let lendingService: LendingService
    let lendingManager: LendingManager
    
    init(
        configuration: AppConfiguration = .live,
        logger: PilotLogger = .live,
        homeService: HomeService = HomeMockService(),
        copilotService: CopilotService = CopilotMockService(),
        moneyService: MoneyService = MoneyMockService(),
        trustService: TrustService = TrustMockService(),
        automationsStorage: AutomationsStorageService = InMemoryAutomationsStorageService(),
        automationRunner: AutomationRunner = AutomationMockRunner(),
        aggregationService: AggregationService = MockAggregationService(),
        integrationManager: IntegrationManager = IntegrationManager(aggregationService: MockAggregationService()),
        lendingService: LendingService = MockLendingService(),
        lendingManager: LendingManager = LendingManager(lendingService: MockLendingService(), trustService: TrustMockService(), moneyService: MoneyMockService())
    ) {
        self.configuration = configuration
        self.logger = logger
        self.homeService = homeService
        self.copilotService = copilotService
        self.moneyService = moneyService
        self.trustService = trustService
        self.automationsStorage = automationsStorage
        self.automationRunner = automationRunner
        self.aggregationService = aggregationService
        self.integrationManager = integrationManager
        self.lendingService = lendingService
        self.lendingManager = lendingManager
    }
}
