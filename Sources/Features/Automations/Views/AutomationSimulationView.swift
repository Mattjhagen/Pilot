import SwiftUI

struct AutomationSimulationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AutomationSimulationViewModel
    
    init(automation: Automation) {
        _viewModel = State(initialValue: AutomationSimulationViewModel(
            runner: DependencyContainer.shared.automationRunner,
            automation: automation
        ))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            VStack(spacing: Spacing.xl) {
                Spacer()
                
                PilotIcon(name: "flask.fill", weight: .light)
                    .font(.system(size: 80))
                    .foregroundColor(.pilotAccent)
                
                VStack(spacing: Spacing.md) {
                    Text("Test Run")
                        .pilotTypography(.pilotTitle)
                    
                    Text("Simulating: \(viewModel.automation.name)")
                        .pilotTypography(.pilotHeadline, color: .pilotSecondaryText)
                }
                
                PilotCard {
                    if viewModel.isLoading {
                        ProgressView("Running simulation...")
                            .frame(maxWidth: .infinity, minHeight: 100)
                    } else if let result = viewModel.resultMessage {
                        Text(result)
                            .pilotTypography(.pilotBody)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 100)
                    } else {
                        Text("Ready to run.")
                            .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                            .frame(maxWidth: .infinity, minHeight: 100)
                    }
                }
                .padding(.horizontal, Spacing.lg)
                
                Spacer()
                
                Button(action: {
                    HapticsManager.shared.lightImpact()
                    Task {
                        await viewModel.runSimulation()
                    }
                }) {
                    Text("Run Simulation")
                        .frame(maxWidth: .infinity)
                }
                .pilotButtonStyle(variant: .primary)
                .disabled(viewModel.isLoading)
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.xl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
