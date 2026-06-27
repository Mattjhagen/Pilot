import SwiftUI

struct RootTabView: View {
    @Environment(AppCoordinator.self) private var coordinator
    
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        
        TabView(selection: $bindableCoordinator.selectedTab) {
            HomeView()
                .environment(coordinator.homeRouter)
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.iconName)
                }
                .tag(AppTab.home)
            
            MoneyView()
                .environment(coordinator.moneyRouter)
                .tabItem {
                    Label(AppTab.money.title, systemImage: AppTab.money.iconName)
                }
                .tag(AppTab.money)
            
            WealthView()
                .environment(coordinator.wealthRouter)
                .tabItem {
                    Label(AppTab.wealth.title, systemImage: AppTab.wealth.iconName)
                }
                .tag(AppTab.wealth)
            
            TrustView()
                .environment(coordinator.trustRouter)
                .tabItem {
                    Label(AppTab.trust.title, systemImage: AppTab.trust.iconName)
                }
                .tag(AppTab.trust)
            
            AIView()
                .environment(coordinator.aiRouter)
                .tabItem {
                    Label(AppTab.ai.title, systemImage: AppTab.ai.iconName)
                }
                .tag(AppTab.ai)
            
            AutomationsView()
                .environment(coordinator.automationsRouter)
                .tabItem {
                    Label(AppTab.automations.title, systemImage: AppTab.automations.iconName)
                }
                .tag(AppTab.automations)
        }
        .tint(.pilotAccent)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
