import SwiftUI

struct LoadingStateView: View {
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .controlSize(.large)
            Text(message)
                .font(.pilotBody)
                .foregroundColor(.pilotSecondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pilotBackground.ignoresSafeArea())
    }
}
