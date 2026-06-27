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
        VStack(spacing: Spacing.large) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.pilotSecondaryText)
            
            VStack(spacing: Spacing.small) {
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
                .pilotButtonStyle(isPrimary: false)
                .padding(.horizontal, Spacing.giant)
            }
        }
        .padding(Spacing.extraLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pilotBackground.ignoresSafeArea())
    }
}
