import Foundation

protocol MoneyService {
    func fetchAccounts() async throws -> [Account]
    func fetchTransactions(for accountId: UUID) async throws -> [Transaction]
}

final class MoneyMockService: MoneyService {
    
    private let accounts: [Account] = [
        Account(id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!, name: "Primary Checking", type: .checking, maskedNumber: "•••• 1234", balance: 4520.50, availableBalance: 4520.50, interestRate: nil, currency: "USD"),
        Account(id: UUID(uuidString: "20000000-0000-0000-0000-000000000002")!, name: "High Yield Savings", type: .savings, maskedNumber: "•••• 5678", balance: 18200.00, availableBalance: nil, interestRate: 4.25, currency: "USD"),
        Account(id: UUID(uuidString: "30000000-0000-0000-0000-000000000003")!, name: "Platinum Rewards Card", type: .creditCard, maskedNumber: "•••• 9012", balance: -1200.45, availableBalance: 8799.55, interestRate: nil, currency: "USD")
    ]
    
    func fetchAccounts() async throws -> [Account] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return accounts
    }
    
    func fetchTransactions(for accountId: UUID) async throws -> [Transaction] {
        try await Task.sleep(nanoseconds: 600_000_000)
        var transactions: [Transaction] = []
        let calendar = Calendar.current
        
        // Generate mock transactions
        for i in 0..<20 {
            let isIncome = i % 7 == 0
            let amount = isIncome ? Double.random(in: 100...2000) : Double.random(in: -200...-5)
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let category: TransactionCategory = isIncome ? .income : [.groceries, .dining, .transportation, .entertainment, .general].randomElement()!
            let status: TransactionStatus = i < 2 ? .pending : .posted
            
            let t = Transaction(
                id: UUID(),
                accountId: accountId,
                date: date,
                description: isIncome ? "Payroll Deposit" : "Card Purchase",
                amount: amount,
                category: category,
                status: status,
                merchant: isIncome ? nil : ["Whole Foods", "Uber", "AMC Theaters", "Starbucks", "Target"].randomElement()!,
                notes: nil
            )
            transactions.append(t)
        }
        
        return transactions.sorted(by: { $0.date > $1.date })
    }
}
