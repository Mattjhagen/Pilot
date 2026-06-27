import Foundation

struct Provider: Identifiable, Equatable, Hashable, Codable {
    let id: UUID
    let name: String
    let logoName: String
}

// Represents the raw account fetched from the third-party integration
struct AggregationAccount: Identifiable, Equatable, Codable {
    let id: UUID
    let providerId: UUID
    let name: String
    let mask: String
    let type: String // e.g., "Checking", "Savings", "CreditCard"
    let balance: Double
    let currency: String
}

// Represents the saved link to an account inside our app
struct LinkedAccount: Identifiable, Equatable, Codable {
    let id: UUID
    let aggregationAccountId: UUID
    let provider: Provider
    let name: String
    let mask: String
    let type: String
    let addedDate: Date
}

enum AggregationError: Error, LocalizedError {
    case authenticationFailed
    case providerUnavailable
    case dataFetchFailed
    case notConfigured
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed:
            return "Failed to securely authenticate with this institution."
        case .providerUnavailable:
            return "This institution is currently undergoing maintenance."
        case .dataFetchFailed:
            return "We could not fetch your accounts at this time."
        case .notConfigured:
            return "The integration layer is not configured."
        }
    }
}
