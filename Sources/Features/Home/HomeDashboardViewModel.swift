import SwiftUI
import Observation

@Observable
final class HomeDashboardViewModel {
    private let service: HomeService
    
    var isLoading = false
    var availableMoney: AvailableMoney?
    var upcomingBills: [UpcomingBill] = []
    var recentTransactions: [RecentTransaction] = []
    var trustScore: TrustScore?
    var savingsProgress: [SavingsProgress] = []
    var creditUtilization: CreditUtilization?
    var subscriptions: [Subscription] = []
    var aiInsights: [AIInsight] = []
    var quickActions: [QuickAction] = []
    
    init(service: HomeService) {
        self.service = service
    }
    
    @MainActor
    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        
        async let moneyTask = service.fetchAvailableMoney()
        async let billsTask = service.fetchUpcomingBills()
        async let transactionsTask = service.fetchRecentTransactions()
        async let trustTask = service.fetchTrustScore()
        async let savingsTask = service.fetchSavingsProgress()
        async let creditTask = service.fetchCreditUtilization()
        async let subsTask = service.fetchSubscriptions()
        async let insightsTask = service.fetchAIInsights()
        async let actionsTask = service.fetchQuickActions()
        
        do {
            self.availableMoney = try await moneyTask
            self.upcomingBills = try await billsTask
            self.recentTransactions = try await transactionsTask
            self.trustScore = try await trustTask
            self.savingsProgress = try await savingsTask
            self.creditUtilization = try await creditTask
            self.subscriptions = try await subsTask
            self.aiInsights = try await insightsTask
            self.quickActions = try await actionsTask
        } catch {
            // Handle error in real app
            print("Failed to load dashboard data: \(error)")
        }
    }
}
