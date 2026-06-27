import Foundation
import Observation

@Observable
final class AppCoordinator {
    var selectedTab: AppTab = .home
    
    // Feature routers
    let homeRouter = Router<HomeRoute>()
    let moneyRouter = Router<MoneyRoute>()
    let wealthRouter = Router<WealthRoute>()
    let trustRouter = Router<TrustRoute>()
    let aiRouter = Router<AIRoute>()
    let automationsRouter = Router<AutomationsRoute>()
    
    func handleDeepLink(_ url: URL) {
        // Deep linking logic goes here. 
        // Example: pilot://money/transaction/1234
        guard let host = url.host else { return }
        
        switch host {
        case "home":
            selectedTab = .home
        case "money":
            selectedTab = .money
        case "wealth":
            selectedTab = .wealth
        case "trust":
            selectedTab = .trust
        case "ai":
            selectedTab = .ai
        case "automations":
            selectedTab = .automations
        default:
            break
        }
    }
}
