import Foundation

final class MockAggregationService: AggregationService {
    
    private let mockProviders = [
        Provider(id: UUID(uuidString: "A0000000-0000-0000-0000-000000000001")!, name: "Mock Bank", logoName: "building.columns.fill"),
        Provider(id: UUID(uuidString: "A0000000-0000-0000-0000-000000000002")!, name: "Mock Investing", logoName: "chart.line.uptrend.xyaxis")
    ]
    
    func listAvailableProviders() async throws -> [Provider] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockProviders
    }
    
    func authenticate(provider: Provider) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        // Simulate a 10% chance of failure
        if Int.random(in: 1...10) == 1 {
            throw AggregationError.authenticationFailed
        }
        // Authentication succeeded in mock
    }
    
    func fetchAccounts(for provider: Provider) async throws -> [AggregationAccount] {
        try await Task.sleep(nanoseconds: 800_000_000)
        
        // Return dummy data. In a real app we'd decode accounts.json here.
        if provider.name.contains("Bank") {
            return [
                AggregationAccount(id: UUID(), providerId: provider.id, name: "Checking", mask: "0001", type: "checking", balance: 5000.0, currency: "USD"),
                AggregationAccount(id: UUID(), providerId: provider.id, name: "Savings", mask: "0002", type: "savings", balance: 12000.0, currency: "USD")
            ]
        } else {
            return [
                AggregationAccount(id: UUID(), providerId: provider.id, name: "Brokerage", mask: "0003", type: "investment", balance: 24500.0, currency: "USD")
            ]
        }
    }
    
    func fetchTransactions(for account: AggregationAccount) async throws -> [Transaction] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return []
    }
    
    func refreshAccount(_ account: AggregationAccount) async throws -> AggregationAccount {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return account
    }
    
    func unlinkAccount(_ account: AggregationAccount) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
