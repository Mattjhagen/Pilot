import Foundation

protocol HomeService {
    func fetchAvailableMoney() async throws -> AvailableMoney
    func fetchUpcomingBills() async throws -> [UpcomingBill]
    func fetchRecentTransactions() async throws -> [RecentTransaction]
    func fetchTrustScore() async throws -> TrustScore
    func fetchSavingsProgress() async throws -> [SavingsProgress]
    func fetchCreditUtilization() async throws -> CreditUtilization
    func fetchSubscriptions() async throws -> [Subscription]
    func fetchAIInsights() async throws -> [AIInsight]
    func fetchQuickActions() async throws -> [QuickAction]
}

final class HomeMockService: HomeService {
    func fetchAvailableMoney() async throws -> AvailableMoney {
        try await Task.sleep(nanoseconds: 500_000_000)
        return AvailableMoney(amount: 4520.50, currencySymbol: "$", description: "Safe to spend")
    }
    
    func fetchUpcomingBills() async throws -> [UpcomingBill] {
        try await Task.sleep(nanoseconds: 300_000_000)
        let calendar = Calendar.current
        return [
            UpcomingBill(title: "Electric Bill", amount: 120.0, dueDate: calendar.date(byAdding: .day, value: 3, to: Date())!),
            UpcomingBill(title: "Internet", amount: 80.0, dueDate: calendar.date(byAdding: .day, value: 5, to: Date())!)
        ]
    }
    
    func fetchRecentTransactions() async throws -> [RecentTransaction] {
        try await Task.sleep(nanoseconds: 200_000_000)
        let calendar = Calendar.current
        return [
            RecentTransaction(merchant: "Whole Foods", amount: 85.20, date: calendar.date(byAdding: .day, value: -1, to: Date())!, isIncome: false),
            RecentTransaction(merchant: "Payroll", amount: 3200.00, date: calendar.date(byAdding: .day, value: -2, to: Date())!, isIncome: true),
            RecentTransaction(merchant: "Uber", amount: 15.50, date: calendar.date(byAdding: .day, value: -3, to: Date())!, isIncome: false)
        ]
    }
    
    func fetchTrustScore() async throws -> TrustScore {
        try await Task.sleep(nanoseconds: 100_000_000)
        return TrustScore(score: 812, maxScore: 850, category: "Excellent")
    }
    
    func fetchSavingsProgress() async throws -> [SavingsProgress] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return [
            SavingsProgress(currentAmount: 15000, goalAmount: 20000, title: "Emergency Fund"),
            SavingsProgress(currentAmount: 3200, goalAmount: 5000, title: "Vacation")
        ]
    }
    
    func fetchCreditUtilization() async throws -> CreditUtilization {
        try await Task.sleep(nanoseconds: 100_000_000)
        return CreditUtilization(usedAmount: 1200, totalLimit: 10000)
    }
    
    func fetchSubscriptions() async throws -> [Subscription] {
        try await Task.sleep(nanoseconds: 400_000_000)
        let calendar = Calendar.current
        return [
            Subscription(serviceName: "Netflix", amount: 15.99, renewalDate: calendar.date(byAdding: .day, value: 12, to: Date())!),
            Subscription(serviceName: "Spotify", amount: 9.99, renewalDate: calendar.date(byAdding: .day, value: 18, to: Date())!)
        ]
    }
    
    func fetchAIInsights() async throws -> [AIInsight] {
        try await Task.sleep(nanoseconds: 600_000_000)
        return [
            AIInsight(title: "Unusual Spending", message: "Your dining out expenses are 20% higher than last month."),
            AIInsight(title: "Save More", message: "You have an extra $300 this month. Consider adding it to your Emergency Fund.")
        ]
    }
    
    func fetchQuickActions() async throws -> [QuickAction] {
        return [
            QuickAction(title: "Pay Bill", iconName: "dollarsign.circle"),
            QuickAction(title: "Transfer", iconName: "arrow.left.arrow.right"),
            QuickAction(title: "Deposit", iconName: "tray.and.arrow.down"),
            QuickAction(title: "Freeze Card", iconName: "lock")
        ]
    }
}
