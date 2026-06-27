import SwiftUI

struct AnimationSystem {
    // Standard micro-animations that feel native and fast
    static let fastSpring = Animation.spring(response: 0.2, dampingFraction: 0.7, blendDuration: 0.1)
    static let mediumSpring = Animation.spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.1)
    static let slowFade = Animation.easeInOut(duration: 0.4)
    
    // For specific common interactions
    static let buttonPress = fastSpring
    static let sheetPresentation = mediumSpring
}
