import Foundation

struct TrustScore: Equatable {
    let score: Int
    let maxScore: Int
    let grade: String
    let trend: Int
    let lastUpdated: Date
}

struct TrustHistoryPoint: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Int
}

struct TrustMetric: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let iconName: String
    let currentValue: Int
    let maxValue: Int
    let weight: Double
    let trend: Int
    let description: String
    let history: [TrustHistoryPoint]
}

struct TrustSuggestion: Identifiable, Equatable {
    let id = UUID()
    let metricId: UUID
    let title: String
    let message: String
}
