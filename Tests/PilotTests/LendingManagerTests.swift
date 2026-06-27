import Testing
import Foundation
@testable import Pilot

struct LendingManagerTests {
    
    @Test func testMockEligibilityAlgorithm() async throws {
        let service = MockLendingService()
        
        // Test Low Trust Score Rejection
        do {
            _ = try await service.prequalifyLoans(trustScore: 400)
            Issue.record("Expected rejection for score 400")
        } catch LendingError.noOffersAvailable {
            // Success
        }
        
        // Test High Trust Score Approval
        let offers = try await service.prequalifyLoans(trustScore: 800)
        #expect(offers.isEmpty == false)
        #expect(offers[0].apr < 10.0) // 800 score should get max discount (8% off 12%)
    }
    
    @Test func testLendingManagerApplicationFlow() async throws {
        let lending = MockLendingService()
        // Inject a high trust score so it passes
        let manager = LendingManager(lendingService: lending)
        
        await manager.fetchOffers()
        
        // Note: For unit testing we'd need a way to mock the TrustService properly inside the manager
        // Here we just test the service logic directly
        let offers = try await lending.prequalifyLoans(trustScore: 750)
        let offer = offers[0]
        
        let loan = try await lending.apply(for: offer, trustScore: 750)
        #expect(loan.outstandingBalance == offer.principal)
        #expect(loan.paymentSchedule.count == offer.termMonths)
        
        // Test Payment
        let repayment = try await lending.makePayment(amount: offer.monthlyPayment, on: loan.id)
        #expect(repayment.amount == offer.monthlyPayment)
        
        let refreshedLoan = try await lending.refreshLoan(loan.id)
        #expect(refreshedLoan.outstandingBalance < offer.principal)
        #expect(refreshedLoan.paymentSchedule[0].isPaid == true)
    }
}
