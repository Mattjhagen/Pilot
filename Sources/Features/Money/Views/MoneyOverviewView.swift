import SwiftUI

struct MoneyOverviewView: View {
    @Environment(Router<MoneyRoute>.self) private var router
    @State private var viewModel: MoneyOverviewViewModel
    
    init() {
        _viewModel = State(initialValue: MoneyOverviewViewModel(
            service: DependencyContainer.shared.moneyService,
            integrationManager: DependencyContainer.shared.integrationManager
        ))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: Spacing.lg) {
                    if viewModel.isLoading && viewModel.accounts.isEmpty {
                        ProgressView()
                            .padding(.top, Spacing.xxl)
                    } else {
                        // Iterating over a predefined order of AccountTypes
                        let orderedTypes: [AccountType] = [.checking, .savings, .creditCard]
                        
                        ForEach(orderedTypes, id: \.self) { type in
                            if let accs = viewModel.groupedAccounts[type], !accs.isEmpty {
                                VStack(alignment: .leading, spacing: Spacing.md) {
                                    Text(type.rawValue.uppercased())
                                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                                        .padding(.leading, Spacing.xs)
                                    
                                    ForEach(accs) { account in
                                        AccountCardView(account: account)
                                            .onTapGesture {
                                                router.push(.accountDetail(id: account.id))
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(Spacing.lg)
            }
            .refreshable {
                HapticsManager.shared.lightImpact()
                await viewModel.loadAccounts()
            }
        }
        .navigationTitle("Money")
        .navigationBarTitleDisplayMode(.large)
        .task {
            if viewModel.accounts.isEmpty {
                await viewModel.loadAccounts()
            }
        }
        .navigationDestination(for: MoneyRoute.self) { route in
            switch route {
            case .dashboard:
                EmptyView()
            case .accountDetail(let id):
                // We'll map the ID back to the account.
                // In a real app we'd pass the account or fetch it by ID in the detail view.
                if let account = viewModel.accounts.first(where: { $0.id == id }) {
                    AccountDetailView(account: account)
                } else {
                    Text("Account not found")
                }
            case .transactionDetail(let transactionId):
                Text("Transaction \(transactionId)")
            }
        }
    }
}

struct AccountCardView: View {
    let account: Account
    
    var body: some View {
        PilotCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack {
                    Text(account.name)
                        .pilotTypography(.pilotHeadline)
                    Spacer()
                    Text(account.maskedNumber)
                        .pilotTypography(.pilotFootnote, color: .pilotSecondaryText)
                }
                
                Text("\(account.currency == "USD" ? "$" : "")\(String(format: "%.2f", account.balance))")
                    .pilotTypography(.pilotLargeTitle, color: account.balance < 0 ? .pilotError : .pilotPrimaryText)
                
                if let available = account.availableBalance {
                    Text("Available: \(account.currency == "USD" ? "$" : "")\(String(format: "%.2f", available))")
                        .pilotTypography(.pilotFootnote, color: .pilotSecondaryText)
                }
            }
        }
    }
}
