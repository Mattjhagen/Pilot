import SwiftUI

struct WealthView: View {
    @Environment(Router<WealthRoute>.self) private var router
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView { sidebar } detail: { detailPlaceholder }
            } else {
                NavigationStack(path: Bindable(router).path) { sidebar }
            }
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            PilotCard {
                Text("Wealth Screen Coming Soon")
                    .pilotTypography(.pilotHeadline)
            }
            .padding(Spacing.lg)
        }
        .navigationTitle("Wealth")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: WealthRoute.self) { route in
            switch route {
            case .dashboard:
                Text("Dashboard")
            case .portfolioDetail:
                Text("Portfolio")
            }
        }
    }
    
    @ViewBuilder
    private var detailPlaceholder: some View {
        Text("Select an asset")
            .pilotTypography(.pilotBody, color: .pilotSecondaryText)
    }
}
