import Foundation

struct LoanOffer: Identifiable, Equatable, Codable {
    let id: UUID
    let title: String
    let principal: Double
    let termMonths: Int
    let apr: Double
    let monthlyPayment: Double
    let fees: Double
    let eligibilityExplanation: String
}

struct LoanApplication: Identifiable, Equatable, Codable {
    let id: UUID
    let offerId: UUID
    let status: ApplicationStatus
    let dateApplied: Date
    let rejectionReason: String?
}

enum ApplicationStatus: String, Codable {
    case pending
    case approved
    case rejected
}

struct Repayment: Identifiable, Equatable, Codable {
    let id: UUID
    let date: Date
    let amount: Double
}

struct ScheduledPayment: Identifiable, Equatable, Codable {
    let id: UUID
    let dueDate: Date
    let amount: Double
    var isPaid: Bool
}

struct LoanAgreement: Identifiable, Equatable, Codable {
    let id: UUID
    let offer: LoanOffer
    let dateOriginated: Date
    var outstandingBalance: Double
    var nextPaymentDate: Date?
    var nextPaymentAmount: Double?
    var paymentSchedule: [ScheduledPayment]
    var history: [Repayment]
}

enum LendingError: Error, LocalizedError {
    case noOffersAvailable
    case applicationDenied(reason: String)
    case paymentFailed
    
    var errorDescription: String? {
        switch self {
        case .noOffersAvailable:
            return "No loan offers are currently available based on your Trust profile."
        case .applicationDenied(let reason):
            return "Application denied: \(reason)"
        case .paymentFailed:
            return "Payment failed. Please try again."
        }
    }
}
