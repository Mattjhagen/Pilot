import SwiftUI

struct AIView: View {
    @Environment(Router<AIRoute>.self) private var router
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
        CopilotView()
        .navigationDestination(for: AIRoute.self) { route in
            switch route {
            case .chat:
                Text("Chat")
            case .history:
                Text("History")
            }
        }
    }
    
    @ViewBuilder
    private var detailPlaceholder: some View {
        Text("Select a conversation")
            .pilotTypography(.pilotBody, color: .pilotSecondaryText)
    }
}
