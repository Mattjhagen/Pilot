import SwiftUI

struct InputBar: View {
    @Binding var text: String
    var onSend: () -> Void
    var onVoice: () -> Void
    
    var body: some View {
        HStack(alignment: .bottom, spacing: Spacing.sm) {
            Button(action: onVoice) {
                PilotIcon(name: "mic.fill", weight: .semibold)
                    .font(.system(size: 20))
                    .foregroundColor(.pilotSecondaryText)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Voice input")
            .accessibilityHint("Starts voice dictation")
            
            TextField("Message Copilot...", text: $text, axis: .vertical)
                .lineLimit(1...5)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(Color.pilotSurface)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.pilotPrimaryText.opacity(0.1), lineWidth: 1)
                )
            
            Button(action: onSend) {
                PilotIcon(name: "arrow.up.circle.fill", weight: .bold)
                    .font(.system(size: 32))
                    .foregroundColor(text.trimmingCharacters(in: .whitespaces).isEmpty ? .pilotSecondaryText.opacity(0.5) : .pilotAccent)
            }
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
            .accessibilityLabel("Send message")
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(GlassView(cornerRadius: 0).ignoresSafeArea(edges: .bottom))
    }
}

struct SuggestionsBar: View {
    let suggestions: [CopilotSuggestion]
    let onSelect: (CopilotSuggestion) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Spacing.sm) {
                ForEach(suggestions) { suggestion in
                    Button(action: {
                        HapticsManager.shared.lightImpact()
                        onSelect(suggestion)
                    }) {
                        HStack(spacing: Spacing.xs) {
                            if let icon = suggestion.iconName {
                                PilotIcon(name: icon)
                            }
                            Text(suggestion.title)
                        }
                        .pilotTypography(.pilotCaption, color: .pilotPrimaryText)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.sm)
                        .background(Color.pilotSurface)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.pilotPrimaryText.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.xs)
        }
    }
}

struct ChatMessageRow: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                userBubble
            } else {
                assistantBubble
                Spacer()
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(message.role == .user ? "You" : "Assistant") said: \(message.content)")
    }
    
    @ViewBuilder
    private var userBubble: some View {
        Text(message.content)
            .pilotTypography(.pilotBody, color: .white)
            .padding(Spacing.md)
            .background(Color.pilotAccent)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    @ViewBuilder
    private var assistantBubble: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(message.content)
                .pilotTypography(.pilotBody, color: .pilotPrimaryText)
            
            if let card = message.card {
                cardView(for: card)
            }
        }
        .padding(Spacing.md)
        .background(Color.pilotSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.pilotPrimaryText.opacity(0.1), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func cardView(for card: CopilotCard) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            switch card {
            case .insight(let title, let description):
                HStack {
                    PilotIcon(name: "sparkles", weight: .semibold).foregroundColor(.pilotAccent)
                    Text(title).pilotTypography(.pilotHeadline)
                }
                Text(description).pilotTypography(.pilotBody, color: .pilotSecondaryText)
                
            case .recommendation(let title, let description, let actionTitle):
                HStack {
                    PilotIcon(name: "star.fill", weight: .semibold).foregroundColor(.pilotWarning)
                    Text(title).pilotTypography(.pilotHeadline)
                }
                Text(description).pilotTypography(.pilotBody, color: .pilotSecondaryText)
                Button(action: { print("Recommendation Action Tapped") }) {
                    Text(actionTitle)
                }
                .pilotButtonStyle(variant: .primary)
                
            case .alert(let title, let description, let actionTitle):
                HStack {
                    PilotIcon(name: "exclamationmark.triangle.fill", weight: .semibold).foregroundColor(.pilotError)
                    Text(title).pilotTypography(.pilotHeadline)
                }
                Text(description).pilotTypography(.pilotBody, color: .pilotSecondaryText)
                Button(action: { print("Alert Action Tapped") }) {
                    Text(actionTitle)
                }
                .pilotButtonStyle(variant: .destructive)
            }
        }
        .padding(Spacing.md)
        .background(Color.pilotBackground)
        .cornerRadius(12)
    }
}
