import SwiftUI
import Observation

enum AppRoute: Hashable {
    case dashboard
    // Add future routes here
}

@Observable
final class NavigationCoordinator {
    var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

struct NavigationCoordinatorView: View {
    @State private var coordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                Color.pilotBackground.ignoresSafeArea()
                Text("Pilot Foundation")
                    .font(.pilotTitle)
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .dashboard:
                    Text("Dashboard placeholder")
                }
            }
        }
        .environment(coordinator)
    }
}
