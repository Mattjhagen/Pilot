import SwiftUI

struct PilotCard<Content: View>: View {
    var hasGlassmorphism: Bool = false
    let content: () -> Content
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(hasGlassmorphism: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.hasGlassmorphism = hasGlassmorphism
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            content()
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if hasGlassmorphism {
                    GlassView(cornerRadius: 16)
                } else {
                    Color.pilotSurface
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.0), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05),
            radius: colorScheme == .dark ? 15 : 10,
            x: 0,
            y: colorScheme == .dark ? 8 : 4
        )
    }
}
