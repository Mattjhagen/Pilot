import Foundation
import Observation

@Observable
final class LendingOverviewViewModel {
    private let manager: LendingManager
    
    var isLoading = false
    
    var activeLoans: [LoanAgreement] { manager.activeLoans }
    var availableOffers: [LoanOffer] { manager.availableOffers }
    
    init(manager: LendingManager) {
        self.manager = manager
    }
    
    @MainActor
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        await manager.fetchActiveLoans()
        await manager.fetchOffers()
    }
}

@Observable
final class ApplicationViewModel {
    private let manager: LendingManager
    let offer: LoanOffer
    
    var isSubmitting = false
    var isSuccess = false
    var errorMessage: String?
    
    init(manager: LendingManager, offer: LoanOffer) {
        self.manager = manager
        self.offer = offer
    }
    
    @MainActor
    func submitApplication() async {
        isSubmitting = true
        errorMessage = nil
        
        do {
            try await manager.apply(for: offer)
            isSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isSubmitting = false
    }
}

@Observable
final class LoanDetailViewModel {
    private let manager: LendingManager
    let loan: LoanAgreement
    
    var isPaying = false
    var paymentSuccess = false
    var errorMessage: String?
    
    init(manager: LendingManager, loan: LoanAgreement) {
        self.manager = manager
        self.loan = loan
    }
    
    @MainActor
    func makePayment(amount: Double) async {
        isPaying = true
        errorMessage = nil
        
        do {
            try await manager.makePayment(amount: amount, on: loan.id)
            paymentSuccess = true
            // Reset success message after delay
            Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                paymentSuccess = false
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isPaying = false
    }
}
