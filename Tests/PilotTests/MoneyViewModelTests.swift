import Testing
import Foundation
@testable import Pilot

struct MoneyViewModelTests {
    
    @Test func testMoneyOverviewGrouping() async {
        let service = MoneyMockService()
        let overviewVM = MoneyOverviewViewModel(service: service)
        
        await overviewVM.loadAccounts()
        
        #expect(overviewVM.accounts.isEmpty == false)
        
        // Ensure grouping works
        let grouped = overviewVM.groupedAccounts
        #expect(grouped[.checking]?.isEmpty == false)
        #expect(grouped[.savings]?.isEmpty == false)
        #expect(grouped[.creditCard]?.isEmpty == false)
    }
    
    @Test func testAccountTransactionFiltering() async {
        let service = MoneyMockService()
        // We know the mock service has this hardcoded account
        let mockAccount = Account(id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!, name: "Test", type: .checking, maskedNumber: "1234", balance: 0, availableBalance: nil, interestRate: nil, currency: "USD")
        let accountVM = AccountViewModel(account: mockAccount, service: service)
        
        await accountVM.loadTransactions()
        
        #expect(accountVM.allTransactions.isEmpty == false)
        #expect(accountVM.groupedTransactions.isEmpty == false)
        
        // Search filter test
        // The mock generates either "Payroll Deposit" or "Card Purchase"
        accountVM.searchText = "Payroll"
        
        let filteredGroups = accountVM.groupedTransactions
        for group in filteredGroups {
            for tx in group.value {
                #expect(tx.description.contains("Payroll"))
            }
        }
    }
}
