import Foundation
import Observation

@Observable
final class LendingManager {
    private let lendingService: LendingService
    private let trustService: TrustService
    private let moneyService: MoneyService // For mock disbursement
    
    var activeLoans: [LoanAgreement] = []
    var availableOffers: [LoanOffer] = []
    
    init(
        lendingService: LendingService = MockLendingService(),
        trustService: TrustService = DependencyContainer.shared.trustService,
        moneyService: MoneyService = DependencyContainer.shared.moneyService
    ) {
        self.lendingService = lendingService
        self.trustService = trustService
        self.moneyService = moneyService
    }
    
    @MainActor
    func fetchActiveLoans() async {
        do {
            activeLoans = try await lendingService.fetchActiveLoans()
        } catch {
            print("Failed to fetch loans: \(error)")
        }
    }
    
    @MainActor
    func fetchOffers() async {
        do {
            let score = try await trustService.fetchScore()
            availableOffers = try await lendingService.prequalifyLoans(trustScore: score.currentScore)
        } catch {
            print("Failed to fetch offers: \(error)")
            availableOffers = []
        }
    }
    
    @MainActor
    func apply(for offer: LoanOffer) async throws {
        let score = try await trustService.fetchScore()
        let agreement = try await lendingService.apply(for: offer, trustScore: score.currentScore)
        activeLoans.append(agreement)
        
        // Mock disbursement: create a transaction on checking account
        // Assuming the first account returned by moneyService is checking
        if let checking = try? await moneyService.fetchAccounts().first(where: { $0.type == .checking }) {
            let disbursementTx = Transaction(
                id: UUID(),
                date: Date(),
                amount: offer.principal,
                merchant: "Pilot Lending",
                description: "Loan Disbursement",
                category: "Transfer",
                isPending: false
            )
            // Note: Since MoneyMockService returns static arrays, this would require 
            // the money service to be mutable to show up. 
            // For now we'll just log it.
            print("Disbursed \(offer.principal) to account \(checking.id)")
            
            // To properly mock this without refactoring MoneyMockService too much,
            // we will just assume it worked.
        }
    }
    
    @MainActor
    func makePayment(amount: Double, on loanId: UUID) async throws {
        _ = try await lendingService.makePayment(amount: amount, on: loanId)
        // Refresh local cache
        if let index = activeLoans.firstIndex(where: { $0.id == loanId }) {
            activeLoans[index] = try await lendingService.refreshLoan(loanId)
        }
        
        // Update trust score by +5 for good behavior
        do {
            var current = try await trustService.fetchScore()
            // Quick mock update
            current = TrustScore(
                currentScore: min(1000, current.currentScore + 5),
                lastUpdated: Date(),
                trend: .up
            )
            print("Trust score improved to \(current.currentScore)")
        } catch {}
    }
}
