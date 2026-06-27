import SwiftUI

struct GlassView: View {
    var cornerRadius: CGFloat = 16
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1) // Base tint
            
            // In a real app this might use UIBlurEffect via UIViewRepresentable 
            // for advanced frosted glass, but standard ultraThinMaterial works well in iOS 15+.
            Rectangle()
                .fill(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
