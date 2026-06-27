import SwiftUI
import SwiftData

@main
struct PilotApp: App {
    @State private var appState = AppState()
    @State private var coordinator = AppCoordinator()
    private let dependencyContainer = DependencyContainer.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(appState)
                .environment(coordinator)
                .environment(dependencyContainer)
                .onOpenURL { url in
                    coordinator.handleDeepLink(url)
                }
        }
        .modelContainer(for: [], inMemory: true) // Replace with actual models in future phases
    }
}
