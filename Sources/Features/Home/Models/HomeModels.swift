import Foundation

struct AvailableMoney: Identifiable {
    let id = UUID()
    let amount: Double
    let currencySymbol: String
    let description: String
}

struct UpcomingBill: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let dueDate: Date
}

struct RecentTransaction: Identifiable {
    let id = UUID()
    let merchant: String
    let amount: Double
    let date: Date
    let isIncome: Bool
}

struct HomeTrustScore: Identifiable {
    let id = UUID()
    let score: Int
    let maxScore: Int
    let category: String // e.g. "Excellent"
}

struct SavingsProgress: Identifiable {
    let id = UUID()
    let currentAmount: Double
    let goalAmount: Double
    let title: String
}

struct CreditUtilization: Identifiable {
    let id = UUID()
    let usedAmount: Double
    let totalLimit: Double
}

struct Subscription: Identifiable {
    let id = UUID()
    let serviceName: String
    let amount: Double
    let renewalDate: Date
}

struct AIInsight: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
}
