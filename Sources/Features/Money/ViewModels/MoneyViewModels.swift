import Foundation
import Observation

@Observable
final class MoneyOverviewViewModel {
    private let service: MoneyService
    private let integrationManager: IntegrationManager
    
    var isLoading = false
    private var baseAccounts: [Account] = []
    
    // Merge base accounts from MoneyService with linked accounts from IntegrationManager
    var accounts: [Account] {
        let linkedAccountsAsCoreAccounts = integrationManager.linkedAccounts.map { linked in
            Account(
                id: linked.id,
                name: "\(linked.provider.name) \(linked.name)",
                type: AccountType(rawValue: linked.type) ?? .checking,
                maskedNumber: linked.mask,
                balance: 0, // Mock doesn't store balance in LinkedAccount right now
                availableBalance: nil,
                interestRate: nil,
                currency: "USD"
            )
        }
        return baseAccounts + linkedAccountsAsCoreAccounts
    }
    
    // Grouping for the UI
    var groupedAccounts: [AccountType: [Account]] {
        Dictionary(grouping: accounts, by: { $0.type })
    }
    
    init(service: MoneyService, integrationManager: IntegrationManager) {
        self.service = service
        self.integrationManager = integrationManager
    }
    
    @MainActor
    func loadAccounts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.baseAccounts = try await service.fetchAccounts()
        } catch {
            print("Failed to load accounts: \(error)")
        }
    }
}

@Observable
final class AccountViewModel {
    private let service: MoneyService
    let account: Account
    
    var isLoading = false
    var allTransactions: [Transaction] = []
    var searchText: String = ""
    
    // Filtered and grouped by Day
    var groupedTransactions: [(key: Date, value: [Transaction])] {
        let filtered = searchText.isEmpty ? allTransactions : allTransactions.filter {
            $0.merchant?.localizedCaseInsensitiveContains(searchText) == true ||
            $0.description.localizedCaseInsensitiveContains(searchText) == true
        }
        
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filtered) { tx in
            calendar.startOfDay(for: tx.date)
        }
        
        return grouped.sorted(by: { $0.key > $1.key })
    }
    
    init(account: Account, service: MoneyService) {
        self.account = account
        self.service = service
    }
    
    @MainActor
    func loadTransactions() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.allTransactions = try await service.fetchTransactions(for: account.id)
        } catch {
            print("Failed to load transactions: \(error)")
        }
    }
}
