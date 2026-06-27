import Foundation
import Observation

@Observable
final class TrustOverviewViewModel {
    private let service: TrustService
    
    var isLoading = false
    var overallScore: TrustScore?
    var metrics: [TrustMetric] = []
    var suggestions: [TrustSuggestion] = []
    
    init(service: TrustService) {
        self.service = service
    }
    
    @MainActor
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            async let metricsTask = service.fetchMetrics()
            async let suggestionsTask = service.fetchSuggestions()
            
            self.metrics = try await metricsTask
            self.suggestions = try await suggestionsTask
            
            self.overallScore = calculateOverallScore(from: self.metrics)
        } catch {
            print("Failed to load trust data: \(error)")
        }
    }
    
    private func calculateOverallScore(from metrics: [TrustMetric]) -> TrustScore {
        guard !metrics.isEmpty else {
            return TrustScore(score: 0, maxScore: 1000, grade: "N/A", trend: 0, lastUpdated: Date())
        }
        
        // Ensure weights add up to 1.0, otherwise normalize
        let totalWeight = metrics.reduce(0.0) { $0 + $1.weight }
        let normalizationFactor = totalWeight > 0 ? (1.0 / totalWeight) : 0
        
        var aggregatedValue = 0.0
        var aggregatedTrend = 0.0
        
        for metric in metrics {
            let normalizedWeight = metric.weight * normalizationFactor
            
            // Map the metric's 0-100 scale to a 0-1000 scale for the overall score calculation
            let scaledMetricScore = Double(metric.currentValue) / Double(metric.maxValue) * 1000.0
            aggregatedValue += (scaledMetricScore * normalizedWeight)
            
            // For trend, just do a simple weighted average of the raw trend values
            aggregatedTrend += (Double(metric.trend) * normalizedWeight)
        }
        
        let finalScore = Int(round(aggregatedValue))
        let finalTrend = Int(round(aggregatedTrend))
        
        // Simple grade mapping
        let grade: String
        switch finalScore {
        case 800...1000: grade = "Excellent"
        case 700..<800: grade = "Good"
        case 600..<700: grade = "Fair"
        default: grade = "Needs Work"
        }
        
        return TrustScore(
            score: finalScore,
            maxScore: 1000,
            grade: grade,
            trend: finalTrend,
            lastUpdated: Date()
        )
    }
}
