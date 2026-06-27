import SwiftUI

struct LendingOverviewView: View {
    @State private var viewModel: LendingOverviewViewModel
    
    init() {
        _viewModel = State(initialValue: LendingOverviewViewModel(manager: DependencyContainer.shared.lendingManager))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.pilotBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        if !viewModel.activeLoans.isEmpty {
                            activeLoansSection
                        }
                        
                        offersSection
                    }
                    .padding(Spacing.lg)
                }
                .refreshable {
                    await viewModel.loadData()
                }
            }
            .navigationTitle("Lending")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadData()
            }
        }
    }
    
    @ViewBuilder
    private var activeLoansSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Active Loans")
                .pilotTypography(.pilotHeadline)
            
            ForEach(viewModel.activeLoans) { loan in
                NavigationLink(destination: LoanDetailView(loan: loan)) {
                    PilotCard {
                        HStack {
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text(loan.offer.title)
                                    .pilotTypography(.pilotBody)
                                    .foregroundColor(.pilotPrimaryText)
                                
                                Text("Outstanding: $\(String(format: "%.2f", loan.outstandingBalance))")
                                    .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                            }
                            Spacer()
                            PilotIcon(name: "chevron.right")
                                .foregroundColor(.pilotSecondaryText)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var offersSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Prequalified Offers")
                .pilotTypography(.pilotHeadline)
            
            if viewModel.isLoading && viewModel.availableOffers.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if viewModel.availableOffers.isEmpty {
                PilotCard {
                    VStack(spacing: Spacing.sm) {
                        PilotIcon(name: "shield.slash.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.pilotSecondaryText)
                        Text("No Offers Available")
                            .pilotTypography(.pilotHeadline)
                        Text("Keep building your Trust Score by paying bills on time to unlock premium rates.")
                            .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            } else {
                ForEach(viewModel.availableOffers) { offer in
                    NavigationLink(destination: OfferDetailView(offer: offer)) {
                        PilotCard {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack {
                                    Text(offer.title)
                                        .pilotTypography(.pilotHeadline, color: .pilotPrimaryText)
                                    Spacer()
                                    Text("\(String(format: "%.1f", offer.apr))% APR")
                                        .pilotTypography(.pilotHeadline, color: .pilotAccent)
                                }
                                
                                HStack {
                                    Text("Up to $\(String(format: "%.0f", offer.principal))")
                                        .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                                    Spacer()
                                    Text("\(offer.termMonths) months")
                                        .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                                }
                                
                                Divider()
                                
                                Text(offer.eligibilityExplanation)
                                    .pilotTypography(.pilotCaption, color: .pilotSuccess)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
            }
        }
    }
}
