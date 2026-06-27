import Foundation

protocol LendingService {
    func prequalifyLoans(trustScore: Int) async throws -> [LoanOffer]
    func apply(for offer: LoanOffer, trustScore: Int) async throws -> LoanAgreement
    func fetchActiveLoans() async throws -> [LoanAgreement]
    func makePayment(amount: Double, on loanId: UUID) async throws -> Repayment
    func refreshLoan(_ loanId: UUID) async throws -> LoanAgreement
}
