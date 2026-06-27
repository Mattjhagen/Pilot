import Testing
import Foundation
@testable import Pilot

struct HomeViewModelTests {
    
    @Test func testRefreshPopulatesData() async {
        let mockService = HomeMockService()
        let viewModel = HomeDashboardViewModel(service: mockService)
        
        #expect(viewModel.availableMoney == nil)
        #expect(viewModel.upcomingBills.isEmpty)
        #expect(viewModel.recentTransactions.isEmpty)
        
        await viewModel.refresh()
        
        #expect(viewModel.availableMoney != nil)
        #expect(viewModel.upcomingBills.isEmpty == false)
        #expect(viewModel.recentTransactions.isEmpty == false)
        #expect(viewModel.trustScore != nil)
        #expect(viewModel.aiInsights.isEmpty == false)
    }
}
