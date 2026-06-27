import SwiftUI

enum PilotButtonStyleVariant {
    case primary
    case secondary
    case ghost
    case destructive
}

struct PilotButtonStyle: ButtonStyle {
    var variant: PilotButtonStyleVariant = .primary
    var isLoading: Bool = false
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                    .padding(.trailing, Spacing.xs)
            }
            configuration.label
                .pilotTypography(.pilotHeadline, color: foregroundColor)
        }
        .padding(.vertical, Spacing.md)
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
        .opacity(isEnabled ? 1.0 : 0.5)
        .scaleEffect(configuration.isPressed && isEnabled ? 0.98 : 1.0)
        .animation(AnimationSystem.buttonPress, value: configuration.isPressed)
        .animation(AnimationSystem.fastSpring, value: isLoading)
        .onChange(of: configuration.isPressed) { _, isPressed in
            if isPressed && isEnabled {
                HapticsManager.shared.lightImpact()
            }
        }
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .primary: return .pilotAccent
        case .secondary: return .pilotSurface
        case .ghost: return .clear
        case .destructive: return .pilotError
        }
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary, .destructive: return .white
        case .secondary: return .pilotPrimaryText
        case .ghost: return .pilotAccent
        }
    }
    
    private var borderColor: Color {
        switch variant {
        case .secondary: return Color.pilotPrimaryText.opacity(0.1)
        default: return .clear
        }
    }
}

extension View {
    func pilotButtonStyle(variant: PilotButtonStyleVariant = .primary, isLoading: Bool = false) -> some View {
        self.buttonStyle(PilotButtonStyle(variant: variant, isLoading: isLoading))
    }
}
