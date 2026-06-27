import Testing
import SwiftUI
@testable import Pilot

struct RouterTests {

    @Test func testRouterPushAndPop() {
        let router = Router<HomeRoute>()
        
        #expect(router.path.count == 0)
        
        router.push(.dashboard)
        #expect(router.path.count == 1)
        
        router.pop()
        #expect(router.path.count == 0)
    }
    
    @Test func testRouterPopToRoot() {
        let router = Router<HomeRoute>()
        
        router.push(.dashboard)
        router.push(.settings)
        #expect(router.path.count == 2)
        
        router.popToRoot()
        #expect(router.path.count == 0)
    }

    @Test func testAppCoordinatorDeepLink() {
        let coordinator = AppCoordinator()
        
        // Initial state
        #expect(coordinator.selectedTab == .home)
        
        // Handle deep link for money
        if let url = URL(string: "pilot://money/transaction/123") {
            coordinator.handleDeepLink(url)
            #expect(coordinator.selectedTab == .money)
        }
    }
}
