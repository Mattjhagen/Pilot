import Foundation
import Observation

@Observable
final class IntegrationListViewModel {
    private let integrationManager: IntegrationManager
    
    var linkedAccounts: [LinkedAccount] {
        integrationManager.linkedAccounts
    }
    
    var isRefreshing: Bool {
        integrationManager.isRefreshing
    }
    
    init(integrationManager: IntegrationManager) {
        self.integrationManager = integrationManager
    }
    
    @MainActor
    func unlink(account: LinkedAccount) async {
        await integrationManager.unlinkAccount(id: account.id)
    }
}

@Observable
final class ProviderSelectionViewModel {
    private let aggregationService: AggregationService
    
    var providers: [Provider] = []
    var isLoading = false
    var errorMessage: String?
    
    var selectedProvider: Provider?
    var isAuthenticating = false
    
    init(aggregationService: AggregationService) {
        self.aggregationService = aggregationService
    }
    
    @MainActor
    func loadProviders() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            providers = try await aggregationService.listAvailableProviders()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func authenticate(provider: Provider) async -> Bool {
        isAuthenticating = true
        errorMessage = nil
        defer { isAuthenticating = false }
        
        do {
            try await aggregationService.authenticate(provider: provider)
            selectedProvider = provider
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}

@Observable
final class AccountLinkingViewModel {
    private let aggregationService: AggregationService
    let provider: Provider
    
    var availableAccounts: [AggregationAccount] = []
    var selectedAccountIds: Set<UUID> = []
    
    var isLoading = false
    var errorMessage: String?
    
    init(provider: Provider, aggregationService: AggregationService) {
        self.provider = provider
        self.aggregationService = aggregationService
    }
    
    @MainActor
    func loadAccounts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            availableAccounts = try await aggregationService.fetchAccounts(for: provider)
            // Pre-select all by default
            selectedAccountIds = Set(availableAccounts.map { $0.id })
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func toggleSelection(for accountId: UUID) {
        if selectedAccountIds.contains(accountId) {
            selectedAccountIds.remove(accountId)
        } else {
            selectedAccountIds.insert(accountId)
        }
    }
}
