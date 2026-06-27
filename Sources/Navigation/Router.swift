import SwiftUI
import Observation

@Observable
final class Router<Route: Hashable> {
    var path = NavigationPath()
    var sheet: GlobalSheetRoute?
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        if !path.isEmpty {
            path.removeLast(path.count)
        }
    }
    
    func presentSheet(_ route: GlobalSheetRoute) {
        self.sheet = route
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
}
