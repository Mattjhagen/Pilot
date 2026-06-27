import SwiftUI

struct IdentityVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showSimulatedAlert = false
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            VStack(spacing: Spacing.xl) {
                Spacer()
                
                PilotIcon(name: "person.crop.circle.badge.checkmark", weight: .light)
                    .font(.system(size: 80))
                    .foregroundColor(.pilotAccent)
                
                VStack(spacing: Spacing.md) {
                    Text("Verify Your Identity")
                        .pilotTypography(.pilotTitle)
                    
                    Text("Proving who you are increases your Trust Score and unlocks higher limits. We'll need a photo of your ID and a quick selfie.")
                        .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.lg)
                }
                
                Spacer()
                
                VStack(spacing: Spacing.md) {
                    Button(action: {
                        HapticsManager.shared.lightImpact()
                        showSimulatedAlert = true
                    }) {
                        Text("Begin Verification")
                            .frame(maxWidth: .infinity)
                    }
                    .pilotButtonStyle(variant: .primary)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Maybe Later")
                            .frame(maxWidth: .infinity)
                    }
                    .pilotButtonStyle(variant: .secondary)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.xl)
            }
        }
        .navigationBarHidden(true)
        .alert("Coming Soon", isPresented: $showSimulatedAlert) {
            Button("OK", role: .cancel) { dismiss() }
        } message: {
            Text("Identity verification is simulated in this phase. No actual personal data is collected.")
        }
    }
}
