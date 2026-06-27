import Foundation

enum AccountType: String {
    case checking = "Checking"
    case savings = "Savings"
    case creditCard = "Credit Card"
}

struct Account: Identifiable, Hashable {
    let id: UUID
    let name: String
    let type: AccountType
    let maskedNumber: String
    let balance: Double
    let availableBalance: Double?
    let interestRate: Double?
    let currency: String
}

enum TransactionStatus: String {
    case pending = "Pending"
    case posted = "Posted"
}

enum TransactionCategory: String {
    case groceries = "Groceries"
    case dining = "Dining"
    case transportation = "Transportation"
    case entertainment = "Entertainment"
    case income = "Income"
    case general = "General"
    
    var iconName: String {
        switch self {
        case .groceries: return "cart.fill"
        case .dining: return "fork.knife"
        case .transportation: return "car.fill"
        case .entertainment: return "ticket.fill"
        case .income: return "briefcase.fill"
        case .general: return "dollarsign.circle.fill"
        }
    }
}

struct Transaction: Identifiable, Hashable {
    let id: UUID
    let accountId: UUID
    let date: Date
    let description: String
    let amount: Double
    let category: TransactionCategory
    let status: TransactionStatus
    let merchant: String?
    let notes: String?
}
