import SwiftUI

struct PilotTextField: View {
    var placeholder: String
    @Binding var text: String
    var errorMessage: String? = nil
    var isSecure: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .focused($isFocused)
            .padding(Spacing.md)
            .background(Color.pilotSurface)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            )
            .animation(AnimationSystem.fastSpring, value: isFocused)
            
            if let error = errorMessage {
                Text(error)
                    .pilotTypography(.pilotCaption, color: .pilotError)
                    .padding(.leading, Spacing.xs)
                    .transition(.opacity)
            }
        }
    }
    
    private var borderColor: Color {
        if errorMessage != nil {
            return .pilotError
        } else if isFocused {
            return .pilotAccent
        } else {
            return Color.pilotPrimaryText.opacity(0.1)
        }
    }
}
