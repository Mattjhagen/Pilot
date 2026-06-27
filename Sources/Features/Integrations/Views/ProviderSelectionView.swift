import SwiftUI

struct ProviderSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ProviderSelectionViewModel
    
    init() {
        _viewModel = State(initialValue: ProviderSelectionViewModel(aggregationService: DependencyContainer.shared.aggregationService))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.pilotBackground.ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Loading institutions...")
                } else {
                    List {
                        ForEach(viewModel.providers) { provider in
                            Button(action: {
                                Task {
                                    if await viewModel.authenticate(provider: provider) {
                                        // Navigate to linking view
                                    }
                                }
                            }) {
                                HStack(spacing: Spacing.md) {
                                    PilotIcon(name: provider.logoName)
                                        .font(.system(size: 24))
                                        .foregroundColor(.pilotPrimaryText)
                                        .frame(width: 32)
                                    
                                    Text(provider.name)
                                        .pilotTypography(.pilotBody)
                                        .foregroundColor(.pilotPrimaryText)
                                    
                                    Spacer()
                                    
                                    PilotIcon(name: "chevron.right")
                                        .foregroundColor(.pilotSecondaryText)
                                        .font(.system(size: 14))
                                }
                            }
                            .padding(.vertical, Spacing.xs)
                        }
                    }
                    .listStyle(.plain)
                }
                
                if viewModel.isAuthenticating {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    PilotCard {
                        VStack(spacing: Spacing.md) {
                            ProgressView()
                            Text("Securely connecting...")
                                .pilotTypography(.pilotBody)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Select Institution")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .task {
                await viewModel.loadProviders()
            }
            .alert("Connection Failed", isPresented: .constant(viewModel.errorMessage != nil), presenting: viewModel.errorMessage) { _ in
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: { msg in
                Text(msg)
            }
            .navigationDestination(item: $viewModel.selectedProvider) { provider in
                AccountLinkingView(provider: provider)
            }
        }
    }
}
