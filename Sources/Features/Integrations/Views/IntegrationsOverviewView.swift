import SwiftUI

struct IntegrationsOverviewView: View {
    @State private var viewModel: IntegrationListViewModel
    @State private var showProviderSelection = false
    
    init() {
        _viewModel = State(initialValue: IntegrationListViewModel(integrationManager: DependencyContainer.shared.integrationManager))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            if viewModel.linkedAccounts.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: Spacing.md) {
                        ForEach(viewModel.linkedAccounts) { account in
                            PilotCard {
                                HStack(spacing: Spacing.md) {
                                    PilotIcon(name: account.provider.logoName, weight: .regular)
                                        .font(.system(size: 32))
                                        .foregroundColor(.pilotAccent)
                                        .frame(width: 40)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(account.provider.name)
                                            .pilotTypography(.pilotHeadline)
                                        Text("\(account.name) (...\(account.mask))")
                                            .pilotTypography(.pilotFootnote, color: .pilotSecondaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        Task { await viewModel.unlink(account: account) }
                                    }) {
                                        Text("Unlink")
                                            .pilotTypography(.pilotCaption, color: .pilotError)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.pilotError.opacity(0.1))
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding(Spacing.lg)
                }
            }
        }
        .navigationTitle("Linked Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showProviderSelection = true
                } label: {
                    PilotIcon(name: "plus", weight: .semibold)
                        .foregroundColor(.pilotAccent)
                }
            }
        }
        .sheet(isPresented: $showProviderSelection) {
            ProviderSelectionView()
        }
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            PilotIcon(name: "link.circle.fill", weight: .light)
                .font(.system(size: 80))
                .foregroundColor(.pilotSecondaryText)
            
            Text("No Linked Accounts")
                .pilotTypography(.pilotTitle)
            
            Text("Connect your external banks and credit cards to see the full picture.")
                .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
            
            Button(action: {
                showProviderSelection = true
            }) {
                Text("Link an Account")
                    .frame(minWidth: 200)
            }
            .pilotButtonStyle(variant: .primary)
            .padding(.top, Spacing.lg)
        }
    }
}
