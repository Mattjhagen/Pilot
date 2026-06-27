import Foundation
import Observation

@Observable
final class IntegrationManager {
    private let aggregationService: AggregationService
    
    var linkedAccounts: [LinkedAccount] = []
    var isRefreshing = false
    
    init(aggregationService: AggregationService = MockAggregationService()) {
        self.aggregationService = aggregationService
        // Normally we'd load persisted accounts from SwiftData here.
    }
    
    @MainActor
    func linkAccounts(_ accounts: [AggregationAccount], from provider: Provider) {
        for acc in accounts {
            let linked = LinkedAccount(
                id: UUID(),
                aggregationAccountId: acc.id,
                provider: provider,
                name: acc.name,
                mask: acc.mask,
                type: acc.type,
                addedDate: Date()
            )
            linkedAccounts.append(linked)
        }
        // In a real implementation, we would save to SwiftData here
    }
    
    @MainActor
    func unlinkAccount(id: UUID) async {
        guard let account = linkedAccounts.first(where: { $0.id == id }) else { return }
        
        do {
            // Reconstruct AggregationAccount for the protocol
            let aggAcc = AggregationAccount(
                id: account.aggregationAccountId,
                providerId: account.provider.id,
                name: account.name,
                mask: account.mask,
                type: account.type,
                balance: 0,
                currency: "USD"
            )
            try await aggregationService.unlinkAccount(aggAcc)
            linkedAccounts.removeAll(where: { $0.id == id })
            // Save to SwiftData
        } catch {
            print("Failed to unlink: \(error)")
        }
    }
    
    @MainActor
    func refreshAll() async {
        isRefreshing = true
        defer { isRefreshing = false }
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            // Call refresh on all linked accounts...
        } catch {
            print("Refresh failed")
        }
    }
}
