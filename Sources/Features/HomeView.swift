import SwiftUI

struct HomeView: View {
    @Environment(Router<HomeRoute>.self) private var router
    @Environment(DependencyContainer.self) private var dependencyContainer
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var viewModel: HomeDashboardViewModel
    
    init() {
        // We will pass the service in the wrapper init or use a workaround.
        // For SwiftUI, state initialization requiring environment needs to be done carefully.
        // As a simple approach for this phase, we initialize with a dummy and replace on appear,
        // OR we use a container view.
        
        // Let's rely on onAppear to inject the service if we can't do it cleanly in init,
        // or just construct the VM directly here for simplicity in this phase since service is static.
        _viewModel = State(initialValue: HomeDashboardViewModel(service: DependencyContainer.shared.homeService))
    }
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    dashboardContent
                } detail: {
                    Text("Select an item")
                        .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                }
            } else {
                NavigationStack(path: Bindable(router).path) {
                    dashboardContent
                }
            }
        }
    }
    
    @ViewBuilder
    private var dashboardContent: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Placeholder for Live Activity (Phase 09)
                    LiveActivityPlaceholder()
                    
                    if horizontalSizeClass == .regular {
                        // iPad Grid Layout
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.lg) {
                            gridItems
                        }
                        .padding(Spacing.lg)
                    } else {
                        // iPhone Stack Layout
                        LazyVStack(spacing: Spacing.lg) {
                            gridItems
                        }
                        .padding(Spacing.lg)
                    }
                }
            }
            .refreshable {
                HapticsManager.shared.lightImpact()
                await viewModel.refresh()
            }
        }
        .navigationTitle("Command Center")
        .navigationBarTitleDisplayMode(.large)
        .task {
            if viewModel.availableMoney == nil && !viewModel.isLoading {
                await viewModel.refresh()
            }
        }
        .navigationDestination(for: HomeRoute.self) { route in
            switch route {
            case .dashboard:
                Text("Dashboard Detail")
            case .insightsDetail(let id):
                Text("Insight \(id)")
            case .settings:
                Text("Settings")
            }
        }
        .sheet(item: Bindable(router).sheet) { sheet in
            switch sheet {
            case .globalSettings:
                StandardSheet(title: "Settings") { Text("Settings Content") }
            case .userProfile:
                StandardSheet(title: "Profile") { Text("Profile Content") }
            case .newAutomation:
                StandardSheet(title: "New Automation") { Text("Automation Content") }
            }
        }
    }
    
    @ViewBuilder
    private var gridItems: some View {
        AvailableMoneyCard(data: viewModel.availableMoney)
            .onTapGesture { router.push(.dashboard) }
        
        if !viewModel.quickActions.isEmpty {
            QuickActionsRow(actions: viewModel.quickActions)
                .padding(.horizontal, -Spacing.lg) // Bleed to edges
        }
        
        AIInsightsCard(insights: viewModel.aiInsights)
        
        UpcomingBillsCard(bills: viewModel.upcomingBills)
        
        HomeTrustScoreCard(score: viewModel.trustScore)
            .onTapGesture { router.push(.dashboard) }
        
        RecentSpendingCard(transactions: viewModel.recentTransactions)
    }
}
