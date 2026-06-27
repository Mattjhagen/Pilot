import SwiftUI

extension Color {
    // Semantic Colors for Pilot
    
    // Background & Surface
    static let pilotBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(white: 0.05, alpha: 1.0) : UIColor(white: 0.98, alpha: 1.0)
    })
    
    static let pilotSurface = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(white: 0.12, alpha: 1.0) : UIColor.white
    })
    
    // Text Colors
    static let pilotPrimaryText = Color(UIColor.label)
    static let pilotSecondaryText = Color(UIColor.secondaryLabel)
    static let pilotTertiaryText = Color(UIColor.tertiaryLabel)
    
    // Accents & State
    static let pilotAccent = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0) : UIColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0)
    })
    
    static let pilotSuccess = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) : UIColor(red: 0.1, green: 0.6, blue: 0.2, alpha: 1.0)
    })
    
    static let pilotWarning = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0) : UIColor(red: 0.9, green: 0.6, blue: 0.0, alpha: 1.0)
    })
    
    static let pilotError = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0) : UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)
    })
}
