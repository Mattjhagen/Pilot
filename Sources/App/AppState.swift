import SwiftUI
import Observation

@Observable
final class AppState {
    var isUserAuthenticated: Bool = false
    var isOffline: Bool = false
    
    init() {}
}
