import SwiftUI

struct AccountLinkingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AccountLinkingViewModel
    
    init(provider: Provider) {
        _viewModel = State(initialValue: AccountLinkingViewModel(
            provider: provider,
            aggregationService: DependencyContainer.shared.aggregationService
        ))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView("Fetching accounts...")
            } else {
                VStack {
                    List {
                        ForEach(viewModel.availableAccounts) { account in
                            Button(action: {
                                viewModel.toggleSelection(for: account.id)
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(account.name)
                                            .pilotTypography(.pilotBody, color: .pilotPrimaryText)
                                        Text("...\(account.mask)")
                                            .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(account.currency == "USD" ? "$" : "")\(String(format: "%.2f", account.balance))")
                                        .pilotTypography(.pilotHeadline, color: .pilotPrimaryText)
                                    
                                    PilotIcon(name: viewModel.selectedAccountIds.contains(account.id) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(viewModel.selectedAccountIds.contains(account.id) ? .pilotAccent : .pilotSecondaryText)
                                        .padding(.leading, Spacing.sm)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    VStack(spacing: Spacing.md) {
                        Button(action: {
                            HapticsManager.shared.lightImpact()
                            let selected = viewModel.availableAccounts.filter { viewModel.selectedAccountIds.contains($0.id) }
                            DependencyContainer.shared.integrationManager.linkAccounts(selected, from: viewModel.provider)
                            
                            // Hacky dismiss to root since we're using a standard sheet without a coordinator for this isolated flow
                            NotificationCenter.default.post(name: NSNotification.Name("DismissIntegrationsSheet"), object: nil)
                        }) {
                            Text("Link \(viewModel.selectedAccountIds.count) Accounts")
                                .frame(maxWidth: .infinity)
                        }
                        .pilotButtonStyle(variant: .primary)
                        .disabled(viewModel.selectedAccountIds.isEmpty)
                    }
                    .padding(Spacing.lg)
                }
            }
        }
        .navigationTitle("Select Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadAccounts()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissIntegrationsSheet"))) { _ in
            dismiss()
        }
    }
}
