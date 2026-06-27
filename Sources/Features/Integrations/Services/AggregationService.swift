import Foundation

protocol AggregationService {
    func listAvailableProviders() async throws -> [Provider]
    func authenticate(provider: Provider) async throws
    func fetchAccounts(for provider: Provider) async throws -> [AggregationAccount]
    func fetchTransactions(for account: AggregationAccount) async throws -> [Transaction]
    func refreshAccount(_ account: AggregationAccount) async throws -> AggregationAccount
    func unlinkAccount(_ account: AggregationAccount) async throws
}
