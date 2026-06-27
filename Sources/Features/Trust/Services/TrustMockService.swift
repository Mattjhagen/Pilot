import Foundation

protocol TrustService {
    func fetchMetrics() async throws -> [TrustMetric]
    func fetchSuggestions() async throws -> [TrustSuggestion]
}

final class TrustMockService: TrustService {
    
    func fetchMetrics() async throws -> [TrustMetric] {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let calendar = Calendar.current
        
        func generateHistory(base: Int, variance: Int) -> [TrustHistoryPoint] {
            var history: [TrustHistoryPoint] = []
            for i in (0..<6).reversed() {
                let date = calendar.date(byAdding: .month, value: -i, to: Date())!
                let value = max(0, min(100, base + Int.random(in: -variance...variance)))
                history.append(TrustHistoryPoint(date: date, value: value))
            }
            return history
        }
        
        return [
            TrustMetric(
                name: "Income Stability",
                iconName: "briefcase.fill",
                currentValue: 85,
                maxValue: 100,
                weight: 0.4,
                trend: 5,
                description: "Measures the consistency and reliability of your income sources over the past year.",
                history: generateHistory(base: 80, variance: 10)
            ),
            TrustMetric(
                name: "Savings Habits",
                iconName: "leaf.fill",
                currentValue: 60,
                maxValue: 100,
                weight: 0.3,
                trend: -2,
                description: "Evaluates your ability to consistently save a portion of your income and build an emergency fund.",
                history: generateHistory(base: 62, variance: 5)
            ),
            TrustMetric(
                name: "Bill History",
                iconName: "calendar.badge.clock",
                currentValue: 95,
                maxValue: 100,
                weight: 0.3,
                trend: 0,
                description: "Tracks your track record of paying recurring bills and obligations on time.",
                history: generateHistory(base: 95, variance: 2)
            )
        ]
    }
    
    func fetchSuggestions() async throws -> [TrustSuggestion] {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        // In a real app, these would be dynamically generated or matched to metric IDs
        return [
            TrustSuggestion(metricId: UUID(), title: "Set up direct deposit", message: "Connecting a direct deposit can improve your Income Stability score."),
            TrustSuggestion(metricId: UUID(), title: "Increase emergency fund", message: "Try saving an extra 5% this month to boost your Savings Habits.")
        ]
    }
}
