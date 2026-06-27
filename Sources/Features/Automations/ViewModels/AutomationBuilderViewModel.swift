import Foundation
import Observation

@Observable
final class AutomationBuilderViewModel {
    private let storage: AutomationsStorageService
    
    // Core state
    var id: UUID = UUID()
    var name: String = ""
    var triggers: [Trigger] = []
    var conditions: [Condition] = []
    var actions: [Action] = []
    var isEnabled: Bool = true
    
    var isNew: Bool = true
    
    // Derived proxy for creating summary
    var currentAutomation: Automation {
        Automation(
            id: id,
            name: name,
            triggers: triggers,
            conditions: conditions,
            actions: actions,
            isEnabled: isEnabled,
            createdDate: Date()
        )
    }
    
    var summary: String {
        guard !triggers.isEmpty || !actions.isEmpty else {
            return "Add a trigger and an action to begin."
        }
        return currentAutomation.generatedSummary
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !triggers.isEmpty && !actions.isEmpty
    }
    
    init(storage: AutomationsStorageService, automation: Automation? = nil) {
        self.storage = storage
        if let auto = automation {
            self.id = auto.id
            self.name = auto.name
            self.triggers = auto.triggers
            self.conditions = auto.conditions
            self.actions = auto.actions
            self.isEnabled = auto.isEnabled
            self.isNew = false
        }
    }
    
    @MainActor
    func save() async throws {
        guard isValid else { return }
        
        if isNew {
            try await storage.create(automation: currentAutomation)
        } else {
            // Need to retain original createdDate in a real app, 
            // but for mock purposes we just use the proxy object
            try await storage.update(automation: currentAutomation)
        }
    }
}

@Observable
final class AutomationSimulationViewModel {
    private let runner: AutomationRunner
    let automation: Automation
    
    var isLoading = false
    var resultMessage: String?
    
    init(runner: AutomationRunner, automation: Automation) {
        self.runner = runner
        self.automation = automation
    }
    
    @MainActor
    func runSimulation() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.resultMessage = try await runner.simulate(automation: automation)
        } catch {
            self.resultMessage = "Simulation failed due to an error."
        }
    }
}
