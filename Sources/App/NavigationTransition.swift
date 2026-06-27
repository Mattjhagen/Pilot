import SwiftUI

struct NavigationTransition {
    // Defines custom transitions for navigation if needed,
    // otherwise standard NavigationStack animations are used.
    static let standard = AnyTransition.opacity.animation(.easeInOut(duration: 0.3))
}
