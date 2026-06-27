import SwiftUI

struct AccountDetailView: View {
    @Environment(Router<MoneyRoute>.self) private var router
    @State private var viewModel: AccountViewModel
    @State private var showSimulatedAlert = false
    @State private var simulatedActionName = ""
    
    init(account: Account) {
        _viewModel = State(initialValue: AccountViewModel(account: account, service: DependencyContainer.shared.moneyService))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    summaryCard
                    quickActions
                    transactionList
                }
                .padding(Spacing.lg)
            }
            .refreshable {
                HapticsManager.shared.lightImpact()
                await viewModel.loadTransactions()
            }
        }
        .navigationTitle(viewModel.account.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.allTransactions.isEmpty {
                await viewModel.loadTransactions()
            }
        }
        .alert("Coming Soon", isPresented: $showSimulatedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(simulatedActionName) is simulated. No real money movement occurs in this phase.")
        }
    }
    
    @ViewBuilder
    private var summaryCard: some View {
        PilotCard {
            VStack(spacing: Spacing.md) {
                Text(viewModel.account.maskedNumber)
                    .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                
                Text("\(viewModel.account.currency == "USD" ? "$" : "")\(String(format: "%.2f", viewModel.account.balance))")
                    .pilotTypography(.pilotLargeTitle, color: viewModel.account.balance < 0 ? .pilotError : .pilotPrimaryText)
                
                if let apy = viewModel.account.interestRate {
                    Text("\(String(format: "%.2f", apy))% APY")
                        .pilotTypography(.pilotFootnote, color: .pilotSuccess)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private var quickActions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.md) {
                actionButton(title: "Send", icon: "paperplane.fill")
                actionButton(title: "Deposit", icon: "tray.and.arrow.down.fill")
                actionButton(title: "Transfer", icon: "arrow.left.arrow.right")
                actionButton(title: "More", icon: "ellipsis")
            }
            .padding(.horizontal, 2)
        }
    }
    
    private func actionButton(title: String, icon: String) -> some View {
        Button(action: {
            simulatedActionName = title
            showSimulatedAlert = true
        }) {
            VStack(spacing: Spacing.xs) {
                PilotIcon(name: icon, weight: .semibold)
                    .font(.system(size: 20))
                    .foregroundColor(.pilotAccent)
                    .frame(width: 50, height: 50)
                    .background(Color.pilotSurface)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                Text(title)
                    .pilotTypography(.pilotCaption, color: .pilotPrimaryText)
            }
        }
    }
    
    @ViewBuilder
    private var transactionList: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Search Bar
            HStack {
                PilotIcon(name: "magnifyingglass").foregroundColor(.pilotSecondaryText)
                TextField("Search transactions", text: $viewModel.searchText)
            }
            .padding(Spacing.sm)
            .background(Color.pilotSurface)
            .cornerRadius(10)
            
            if viewModel.isLoading && viewModel.allTransactions.isEmpty {
                ProgressView().frame(maxWidth: .infinity)
            } else if viewModel.groupedTransactions.isEmpty {
                Text("No transactions found.")
                    .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                LazyVStack(alignment: .leading, spacing: Spacing.lg) {
                    ForEach(viewModel.groupedTransactions, id: \.key) { group in
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            Text(group.key.formatted(date: .abbreviated, time: .omitted))
                                .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                            
                            VStack(spacing: 0) {
                                ForEach(group.value) { tx in
                                    TransactionRowView(transaction: tx)
                                        .onTapGesture {
                                            router.push(.transactionDetail(id: tx.id))
                                        }
                                    if tx.id != group.value.last?.id {
                                        Divider().padding(.leading, 40)
                                    }
                                }
                            }
                            .background(Color.pilotSurface)
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            PilotIcon(name: transaction.category.iconName)
                .foregroundColor(.pilotSecondaryText)
                .frame(width: 40, height: 40)
                .background(Color.pilotPrimaryText.opacity(0.05))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.merchant ?? transaction.description)
                    .pilotTypography(.pilotBody)
                    .lineLimit(1)
                
                if transaction.status == .pending {
                    Text("Pending")
                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                        .italic()
                } else {
                    Text(transaction.category.rawValue)
                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                }
            }
            
            Spacer()
            
            Text("\(transaction.amount > 0 ? "+" : "")$\(String(format: "%.2f", abs(transaction.amount)))")
                .pilotTypography(.pilotBody, color: transaction.amount > 0 ? .pilotSuccess : .pilotPrimaryText)
        }
        .padding(Spacing.md)
        .contentShape(Rectangle())
    }
}
