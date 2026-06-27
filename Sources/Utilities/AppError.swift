import Foundation

enum AppError: LocalizedError {
    case networkError(Error)
    case unauthenticated
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network connection failed: \(error.localizedDescription)"
        case .unauthenticated:
            return "Please log in to continue."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}
