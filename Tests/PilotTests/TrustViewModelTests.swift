import Testing
import Foundation
@testable import Pilot

struct TrustViewModelTests {
    
    @Test func testTrustScoreCalculation() async {
        let service = TrustMockService()
        let overviewVM = TrustOverviewViewModel(service: service)
        
        await overviewVM.loadData()
        
        #expect(overviewVM.metrics.isEmpty == false)
        #expect(overviewVM.overallScore != nil)
        
        // Let's manually verify the math for the mock service
        // Weights: 0.4, 0.3, 0.3 (Total = 1.0)
        // Income Stability: 85/100 -> 850
        // Savings Habits: 60/100 -> 600
        // Bill History: 95/100 -> 950
        //
        // 850 * 0.4 = 340
        // 600 * 0.3 = 180
        // 950 * 0.3 = 285
        // Total = 805
        
        if let score = overviewVM.overallScore {
            #expect(score.score == 805)
            #expect(score.grade == "Excellent") // 805 falls in 800...1000
        }
    }
}
