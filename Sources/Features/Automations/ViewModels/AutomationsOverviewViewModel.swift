import Foundation
import Observation

@Observable
final class AutomationsOverviewViewModel {
    private let storage: AutomationsStorageService
    
    var isLoading = false
    var automations: [Automation] = []
    
    init(storage: AutomationsStorageService) {
        self.storage = storage
    }
    
    @MainActor
    func loadAutomations() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.automations = try await storage.fetchAll()
        } catch {
            print("Failed to fetch automations: \(error)")
        }
    }
    
    @MainActor
    func toggleAutomation(id: UUID) async {
        guard let index = automations.firstIndex(where: { $0.id == id }) else { return }
        automations[index].isEnabled.toggle()
        
        do {
            try await storage.update(automation: automations[index])
        } catch {
            // Revert on failure
            automations[index].isEnabled.toggle()
            print("Failed to toggle automation: \(error)")
        }
    }
    
    @MainActor
    func deleteAutomation(id: UUID) async {
        do {
            try await storage.delete(id: id)
            self.automations.removeAll(where: { $0.id == id })
        } catch {
            print("Failed to delete automation: \(error)")
        }
    }
}
