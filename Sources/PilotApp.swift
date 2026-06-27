import SwiftUI
import SwiftData

@main
struct PilotApp: App {
    @State private var appState = AppState()
    private let dependencyContainer = DependencyContainer.shared

    var body: some Scene {
        WindowGroup {
            NavigationCoordinatorView()
                .environment(appState)
                .environment(dependencyContainer)
        }
        .modelContainer(for: [], inMemory: true) // Replace with actual models in future phases
    }
}
