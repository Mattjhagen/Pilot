import Foundation
import Observation

@Observable
final class MoneyOverviewViewModel {
    private let service: MoneyService
    
    var isLoading = false
    var accounts: [Account] = []
    
    // Grouping for the UI
    var groupedAccounts: [AccountType: [Account]] {
        Dictionary(grouping: accounts, by: { $0.type })
    }
    
    init(service: MoneyService) {
        self.service = service
    }
    
    @MainActor
    func loadAccounts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.accounts = try await service.fetchAccounts()
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
