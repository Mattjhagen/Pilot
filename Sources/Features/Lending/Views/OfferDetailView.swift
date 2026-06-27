import SwiftUI

struct OfferDetailView: View {
    let offer: LoanOffer
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    PilotCard {
                        VStack(spacing: Spacing.md) {
                            Text(offer.title)
                                .pilotTypography(.pilotTitle)
                            
                            HStack(spacing: Spacing.xl) {
                                VStack {
                                    Text("Principal")
                                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                                    Text("$\(String(format: "%.0f", offer.principal))")
                                        .pilotTypography(.pilotHeadline)
                                }
                                
                                VStack {
                                    Text("Term")
                                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                                    Text("\(offer.termMonths) mo")
                                        .pilotTypography(.pilotHeadline)
                                }
                                
                                VStack {
                                    Text("APR")
                                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                                    Text("\(String(format: "%.1f", offer.apr))%")
                                        .pilotTypography(.pilotHeadline, color: .pilotAccent)
                                }
                            }
                        }
                        .padding(.vertical, Spacing.md)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Repayment Details")
                            .pilotTypography(.pilotHeadline)
                        
                        PilotCard {
                            VStack(spacing: Spacing.sm) {
                                detailRow(title: "Monthly Payment", value: "$\(String(format: "%.2f", offer.monthlyPayment))")
                                detailRow(title: "Origination Fee", value: "$\(String(format: "%.2f", offer.fees))")
                                
                                let total = (offer.monthlyPayment * Double(offer.termMonths)) + offer.fees
                                Divider()
                                detailRow(title: "Total Repayment", value: "$\(String(format: "%.2f", total))")
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Educational Tip")
                            .pilotTypography(.pilotHeadline)
                        
                        PilotCard {
                            HStack(alignment: .top, spacing: Spacing.md) {
                                PilotIcon(name: "lightbulb.fill")
                                    .foregroundColor(.pilotWarning)
                                Text("Only borrow what you need. Missing payments will impact your Trust Score.")
                                    .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                            }
                        }
                    }
                    
                    NavigationLink(destination: ApplicationFormView(offer: offer)) {
                        Text("Continue Application")
                            .frame(maxWidth: .infinity)
                    }
                    .pilotButtonStyle(variant: .primary)
                    .padding(.top, Spacing.lg)
                }
                .padding(Spacing.lg)
            }
        }
        .navigationTitle("Offer Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .pilotTypography(.pilotBody, color: .pilotSecondaryText)
            Spacer()
            Text(value)
                .pilotTypography(.pilotHeadline, color: .pilotPrimaryText)
        }
    }
}

struct ApplicationFormView: View {
    let offer: LoanOffer
    @State private var viewModel: ApplicationViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var agreedToTerms = false
    
    init(offer: LoanOffer) {
        self.offer = offer
        _viewModel = State(initialValue: ApplicationViewModel(manager: DependencyContainer.shared.lendingManager, offer: offer))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            if viewModel.isSuccess {
                successState
            } else {
                formState
            }
        }
        .navigationTitle("Application")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var formState: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Employment Status")
                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                    Text("Verified via Payroll API")
                        .pilotTypography(.pilotBody)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.pilotSurface)
                        .cornerRadius(10)
                        .opacity(0.7)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Identity")
                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                    Text("Verified via KYC Provider")
                        .pilotTypography(.pilotBody)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.pilotSurface)
                        .cornerRadius(10)
                        .opacity(0.7)
                }
                
                Toggle(isOn: $agreedToTerms) {
                    Text("I have read and agree to the Loan Terms and Conditions.")
                        .pilotTypography(.pilotCaption)
                }
                .tint(.pilotAccent)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .pilotTypography(.pilotCaption, color: .pilotError)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    HapticsManager.shared.lightImpact()
                    Task { await viewModel.submitApplication() }
                }) {
                Group {
                    if viewModel.isSubmitting {
                        ProgressView().tint(.white)
                    } else {
                        Text("Sign & Submit")
                    }
                }
                .frame(maxWidth: .infinity)
                }
                .pilotButtonStyle(variant: .primary)
                .disabled(!agreedToTerms || viewModel.isSubmitting)
            }
            .padding(Spacing.lg)
        }
    }
    
    private var successState: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            PilotIcon(name: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.pilotSuccess)
            
            Text("Approved!")
                .pilotTypography(.pilotTitle)
            
            Text("Your loan has been originated and funds will be deposited into your account shortly.")
                .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
            
            Spacer()
            
            Button("Done") {
                // Should use a coordinator, using a hack to pop to root
                NotificationCenter.default.post(name: NSNotification.Name("PopToRootLending"), object: nil)
            }
            .pilotButtonStyle(variant: .primary)
            .padding(Spacing.lg)
        }
    }
}
