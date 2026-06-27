import SwiftUI
import Observation

@Observable
final class ThemeManager {
    var preferredColorScheme: ColorScheme? = nil // nil means system preference
    
    func toggleTheme() {
        if preferredColorScheme == .dark {
            preferredColorScheme = .light
        } else {
            preferredColorScheme = .dark
        }
    }
}
