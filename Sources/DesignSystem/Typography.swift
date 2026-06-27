import SwiftUI

extension Font {
    // Semantic typography for Pilot using standard Dynamic Type text styles
    
    static let pilotLargeTitle = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let pilotTitle = Font.system(.title, design: .rounded).weight(.semibold)
    static let pilotHeadline = Font.system(.headline, design: .default).weight(.semibold)
    static let pilotSubheadline = Font.system(.subheadline, design: .default).weight(.medium)
    static let pilotBody = Font.system(.body, design: .default)
    static let pilotCallout = Font.system(.callout, design: .default)
    static let pilotCaption = Font.system(.caption, design: .default).weight(.regular)
    static let pilotFootnote = Font.system(.footnote, design: .default).weight(.light)
}

struct PilotTypographyModifier: ViewModifier {
    let font: Font
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func pilotTypography(_ font: Font, color: Color = .pilotPrimaryText) -> some View {
        self.modifier(PilotTypographyModifier(font: font, color: color))
    }
}
