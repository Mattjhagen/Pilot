import SwiftUI

extension Color {
    // Semantic Colors for Pilot
    
    // Background & Surface
    static let pilotBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "#000000") : UIColor(hex: "#FFFFFF") // Assuming pure black/white for root backgrounds
    })
    
    static let pilotSurface = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "#0D0D0D") : UIColor(hex: "#F7F7F7")
    })
    
    // Text Colors
    static let pilotPrimaryText = Color(UIColor.label)
    static let pilotSecondaryText = Color(UIColor.secondaryLabel)
    static let pilotTertiaryText = Color(UIColor.tertiaryLabel)
    
    // Accents & State
    static let pilotAccent = Color(UIColor(hex: "#007AFF"))
    static let pilotSuccess = Color(UIColor(hex: "#34C759"))
    static let pilotWarning = Color(UIColor(hex: "#FFD60A"))
    static let pilotError = Color(UIColor(hex: "#FF3B30"))
    static let pilotNeutral = Color(UIColor(hex: "#8E8E93"))
}

fileprivate extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
