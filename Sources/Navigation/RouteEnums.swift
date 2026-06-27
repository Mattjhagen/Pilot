import Foundation

// MARK: - App Tabs
enum AppTab: Int, Hashable, CaseIterable {
    case home
    case money
    case wealth
    case trust
    case ai
    case automations
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .money: return "Money"
        case .wealth: return "Wealth"
        case .trust: return "Trust"
        case .ai: return "AI"
        case .automations: return "Automations"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .money: return "creditcard.fill"
        case .wealth: return "chart.bar.xaxis"
        case .trust: return "shield.lefthalf.filled"
        case .ai: return "bolt.horizontal.fill"
        case .automations: return "gearshape.2"
        }
    }
}

// MARK: - Route Enums per Feature
enum HomeRoute: Hashable {
    case dashboard
    case insightsDetail(id: UUID)
    case settings
}

enum MoneyRoute: Hashable {
    case dashboard
    case transactionDetail(id: UUID)
}

enum WealthRoute: Hashable {
    case dashboard
    case portfolioDetail
}

enum TrustRoute: Hashable {
    case dashboard
    case scoreHistory
}

enum AIRoute: Hashable {
    case chat
    case history
}

enum AutomationsRoute: Hashable {
    case dashboard
    case editAutomation(id: UUID)
}

// MARK: - Global Modal Sheets
enum GlobalSheetRoute: Hashable, Identifiable {
    case userProfile
    case globalSettings
    case newAutomation
    
    var id: Int { hashValue }
}
