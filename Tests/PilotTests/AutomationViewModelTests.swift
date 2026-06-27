import Testing
import Foundation
@testable import Pilot

struct AutomationViewModelTests {
    
    @Test func testAutomationNaturalLanguageGeneration() {
        let trigger = Trigger.paycheckReceived(percentage: 0.1)
        let condition = Condition.balanceGreaterThan(amount: 1000)
        let action = Action.transferToSavings(amount: 50, percentage: false)
        
        let automation = Automation(
            id: UUID(),
            name: "Save Paycheck",
            triggers: [trigger],
            conditions: [condition],
            actions: [action],
            isEnabled: true,
            createdDate: Date()
        )
        
        let summary = automation.generatedSummary
        // Expected: "When a paycheck is received (10%) if balance > $1000, Transfer $50 to Savings."
        // We do a basic string matching test
        #expect(summary.contains("paycheck is received"))
        #expect(summary.contains("balance > $1000"))
        #expect(summary.contains("Transfer $50 to Savings"))
    }
    
    @Test func testAutomationsStorageService() async throws {
        let storage = InMemoryAutomationsStorageService()
        
        var automations = try await storage.fetchAll()
        let initialCount = automations.count
        
        let newAuto = Automation(
            id: UUID(),
            name: "Test Rule",
            triggers: [.recurringWeekly],
            conditions: [],
            actions: [.roundUpPurchases],
            isEnabled: true,
            createdDate: Date()
        )
        
        // Test Create
        try await storage.create(automation: newAuto)
        automations = try await storage.fetchAll()
        #expect(automations.count == initialCount + 1)
        
        // Test Update
        var updatedAuto = newAuto
        updatedAuto.isEnabled = false
        try await storage.update(automation: updatedAuto)
        automations = try await storage.fetchAll()
        #expect(automations.first(where: { $0.id == newAuto.id })?.isEnabled == false)
        
        // Test Delete
        try await storage.delete(id: newAuto.id)
        automations = try await storage.fetchAll()
        #expect(automations.count == initialCount)
    }
}
