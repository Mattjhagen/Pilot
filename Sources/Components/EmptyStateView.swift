import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        title: String,
        message: String,
        systemImage: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.pilotSecondaryText)
            
            VStack(spacing: Spacing.sm) {
                Text(title)
                    .font(.pilotHeadline)
                    .foregroundColor(.pilotPrimaryText)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.pilotBody)
                    .foregroundColor(.pilotSecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .pilotButtonStyle(variant: .secondary)
                .padding(.horizontal, Spacing.xl)
            }
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pilotBackground.ignoresSafeArea())
    }
}
