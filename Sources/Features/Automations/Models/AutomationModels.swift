import Foundation

enum Trigger: Equatable, Hashable {
    case paycheckReceived(percentage: Double)
    case purchaseMade(category: String?)
    case balanceAbove(amount: Double)
    case balanceBelow(amount: Double)
    case dayOfMonth(Int)
    case recurringWeekly
    
    var description: String {
        switch self {
        case .paycheckReceived(let p):
            return "When a paycheck is received (\(Int(p * 100))%)"
        case .purchaseMade(let c):
            if let c = c { return "When a \(c) purchase is made" }
            return "When any purchase is made"
        case .balanceAbove(let a):
            return "When balance goes above $\(Int(a))"
        case .balanceBelow(let a):
            return "When balance drops below $\(Int(a))"
        case .dayOfMonth(let d):
            return "On day \(d) of the month"
        case .recurringWeekly:
            return "Every week"
        }
    }
}

enum Condition: Equatable, Hashable {
    case balanceGreaterThan(amount: Double)
    case balanceLessThan(amount: Double)
    case categoryEquals(String)
    case dayIsWeekend
    
    var description: String {
        switch self {
        case .balanceGreaterThan(let a):
            return "if balance > $\(Int(a))"
        case .balanceLessThan(let a):
            return "if balance < $\(Int(a))"
        case .categoryEquals(let c):
            return "if category is \(c)"
        case .dayIsWeekend:
            return "if it's the weekend"
        }
    }
}

enum Action: Equatable, Hashable {
    case transferToSavings(amount: Double, percentage: Bool)
    case invest(amount: Double, percentage: Bool)
    case pauseSubscription(id: String)
    case sendNotification(message: String)
    case roundUpPurchases
    case moveExcessToSavings(threshold: Double)
    
    var description: String {
        switch self {
        case .transferToSavings(let a, let isPercent):
            return "Transfer \(isPercent ? "\(Int(a * 100))%" : "$\(Int(a))") to Savings"
        case .invest(let a, let isPercent):
            return "Invest \(isPercent ? "\(Int(a * 100))%" : "$\(Int(a))")"
        case .pauseSubscription(let id):
            return "Pause subscription \(id)"
        case .sendNotification(let m):
            return "Notify: '\(m)'"
        case .roundUpPurchases:
            return "Round up to nearest dollar"
        case .moveExcessToSavings(let t):
            return "Move balance over $\(Int(t)) to Savings"
        }
    }
}

struct Automation: Identifiable, Equatable, Hashable {
    let id: UUID
    var name: String
    var triggers: [Trigger]
    var conditions: [Condition]
    var actions: [Action]
    var isEnabled: Bool
    let createdDate: Date
    
    var generatedSummary: String {
        let tString = triggers.map { $0.description.lowercased().replacingOccurrences(of: "when ", with: "") }.joined(separator: " or ")
        let cString = conditions.map { $0.description }.joined(separator: " and ")
        let aString = actions.map { $0.description }.joined(separator: " and ")
        
        var summary = "When \(tString), \(aString)."
        if !conditions.isEmpty {
            summary = "When \(tString) \(cString), \(aString)."
        }
        
        // Capitalize first letter
        if let first = summary.first {
            return first.uppercased() + summary.dropFirst()
        }
        return summary
    }
}
