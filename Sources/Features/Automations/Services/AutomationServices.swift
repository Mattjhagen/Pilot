import Foundation

protocol AutomationsStorageService {
    func fetchAll() async throws -> [Automation]
    func create(automation: Automation) async throws
    func update(automation: Automation) async throws
    func delete(id: UUID) async throws
}

final class InMemoryAutomationsStorageService: AutomationsStorageService {
    private var automations: [Automation] = []
    
    init() {
        // Pre-populate with a few templates
        let a1 = Automation(
            id: UUID(),
            name: "Payday Savings",
            triggers: [.paycheckReceived(percentage: 1.0)],
            conditions: [],
            actions: [.transferToSavings(amount: 0.1, percentage: true)],
            isEnabled: true,
            createdDate: Date()
        )
        
        let a2 = Automation(
            id: UUID(),
            name: "Round-up Purchases",
            triggers: [.purchaseMade(category: nil)],
            conditions: [],
            actions: [.roundUpPurchases],
            isEnabled: true,
            createdDate: Date()
        )
        
        automations = [a1, a2]
    }
    
    func fetchAll() async throws -> [Automation] {
        return automations
    }
    
    func create(automation: Automation) async throws {
        automations.append(automation)
    }
    
    func update(automation: Automation) async throws {
        if let index = automations.firstIndex(where: { $0.id == automation.id }) {
            automations[index] = automation
        }
    }
    
    func delete(id: UUID) async throws {
        automations.removeAll(where: { $0.id == id })
    }
}

protocol AutomationRunner {
    func simulate(automation: Automation) async throws -> String
}

final class AutomationMockRunner: AutomationRunner {
    func simulate(automation: Automation) async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Very basic mock simulation logic
        let hasSavingsAction = automation.actions.contains { action in
            if case .transferToSavings = action { return true }
            if case .moveExcessToSavings = action { return true }
            if case .roundUpPurchases = action { return true }
            return false
        }
        
        if hasSavingsAction {
            let mockAmount = Int.random(in: 50...400)
            return "Over the last 30 days, this rule would have executed 4 times, saving a total of $\(mockAmount)."
        } else {
            return "Over the last 30 days, this rule would have triggered 12 times successfully."
        }
    }
}
