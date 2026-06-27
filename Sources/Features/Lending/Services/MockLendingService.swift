import Foundation

final class MockLendingService: LendingService {
    private var activeLoans: [LoanAgreement] = []
    
    func prequalifyLoans(trustScore: Int) async throws -> [LoanOffer] {
        try await Task.sleep(nanoseconds: 800_000_000)
        
        if trustScore < 500 {
            throw LendingError.noOffersAvailable
        }
        
        // Generate better rates for higher trust scores
        let baseRate = 12.0
        let discount = min(Double(trustScore - 500) / 100.0 * 2.0, 8.0)
        let rate = baseRate - discount
        
        return [
            LoanOffer(
                id: UUID(),
                title: "Personal Loan",
                principal: 5000.0,
                termMonths: 36,
                apr: rate,
                monthlyPayment: calculateMonthlyPayment(principal: 5000.0, rate: rate, months: 36),
                fees: 50.0,
                eligibilityExplanation: "Because your Trust Score is \(trustScore), you qualify for our discounted rate."
            ),
            LoanOffer(
                id: UUID(),
                title: "Credit Builder",
                principal: 1000.0,
                termMonths: 12,
                apr: rate + 2.0, // slightly higher for short term
                monthlyPayment: calculateMonthlyPayment(principal: 1000.0, rate: rate + 2.0, months: 12),
                fees: 0.0,
                eligibilityExplanation: "Build your score quickly with this short-term loan."
            )
        ]
    }
    
    func apply(for offer: LoanOffer, trustScore: Int) async throws -> LoanAgreement {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        if trustScore < 500 {
            throw LendingError.applicationDenied(reason: "Trust score recently dropped below minimum threshold.")
        }
        
        // Generate a simple schedule
        var schedule: [ScheduledPayment] = []
        let calendar = Calendar.current
        var nextDate = calendar.date(byAdding: .month, value: 1, to: Date())!
        
        for _ in 0..<offer.termMonths {
            schedule.append(ScheduledPayment(id: UUID(), dueDate: nextDate, amount: offer.monthlyPayment, isPaid: false))
            nextDate = calendar.date(byAdding: .month, value: 1, to: nextDate)!
        }
        
        let agreement = LoanAgreement(
            id: UUID(),
            offer: offer,
            dateOriginated: Date(),
            outstandingBalance: offer.principal, // ignoring interest capitalization for mock simplicity
            nextPaymentDate: schedule.first?.dueDate,
            nextPaymentAmount: offer.monthlyPayment,
            paymentSchedule: schedule,
            history: []
        )
        
        activeLoans.append(agreement)
        return agreement
    }
    
    func fetchActiveLoans() async throws -> [LoanAgreement] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return activeLoans
    }
    
    func makePayment(amount: Double, on loanId: UUID) async throws -> Repayment {
        try await Task.sleep(nanoseconds: 800_000_000)
        
        guard let index = activeLoans.firstIndex(where: { $0.id == loanId }) else {
            throw LendingError.paymentFailed
        }
        
        var loan = activeLoans[index]
        loan.outstandingBalance = max(0, loan.outstandingBalance - amount)
        
        let repayment = Repayment(id: UUID(), date: Date(), amount: amount)
        loan.history.append(repayment)
        
        // Mark first unpaid schedule as paid if amount matches roughly
        if let scheduleIndex = loan.paymentSchedule.firstIndex(where: { !$0.isPaid }) {
            loan.paymentSchedule[scheduleIndex].isPaid = true
            // Update next payment date
            if let nextUnpaid = loan.paymentSchedule.first(where: { !$0.isPaid }) {
                loan.nextPaymentDate = nextUnpaid.dueDate
                loan.nextPaymentAmount = nextUnpaid.amount
            } else {
                loan.nextPaymentDate = nil
                loan.nextPaymentAmount = nil
            }
        }
        
        activeLoans[index] = loan
        return repayment
    }
    
    func refreshLoan(_ loanId: UUID) async throws -> LoanAgreement {
        guard let loan = activeLoans.first(where: { $0.id == loanId }) else {
            throw LendingError.paymentFailed
        }
        return loan
    }
    
    private func calculateMonthlyPayment(principal: Double, rate: Double, months: Int) -> Double {
        let monthlyRate = (rate / 100.0) / 12.0
        if monthlyRate == 0 { return principal / Double(months) }
        let payment = principal * (monthlyRate * pow(1 + monthlyRate, Double(months))) / (pow(1 + monthlyRate, Double(months)) - 1)
        return payment
    }
}
