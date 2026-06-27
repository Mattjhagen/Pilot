import SwiftUI

struct LoanDetailView: View {
    @State private var viewModel: LoanDetailViewModel
    
    init(loan: LoanAgreement) {
        _viewModel = State(initialValue: LoanDetailViewModel(manager: DependencyContainer.shared.lendingManager, loan: loan))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    
                    PilotCard {
                        VStack(spacing: Spacing.md) {
                            Text("Outstanding Balance")
                                .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                            Text("$\(String(format: "%.2f", viewModel.loan.outstandingBalance))")
                                .pilotTypography(.pilotTitle)
                            
                            ProgressView(value: viewModel.loan.offer.principal - viewModel.loan.outstandingBalance, total: viewModel.loan.offer.principal)
                                .tint(.pilotAccent)
                        }
                    }
                    
                    if let nextDate = viewModel.loan.nextPaymentDate, let nextAmt = viewModel.loan.nextPaymentAmount {
                        PilotCard {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Next Payment")
                                        .pilotTypography(.pilotHeadline)
                                    Text(nextDate, style: .date)
                                        .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                                }
                                Spacer()
                                Text("$\(String(format: "%.2f", nextAmt))")
                                    .pilotTypography(.pilotHeadline)
                            }
                        }
                    } else {
                        PilotCard {
                            Text("Paid in Full")
                                .pilotTypography(.pilotHeadline, color: .pilotSuccess)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .pilotTypography(.pilotCaption, color: .pilotError)
                    }
                    
                    if viewModel.paymentSuccess {
                        Text("Payment Successful!")
                            .pilotTypography(.pilotHeadline, color: .pilotSuccess)
                    }
                    
                    Button(action: {
                        HapticsManager.shared.lightImpact()
                        Task { 
                            if let nextAmt = viewModel.loan.nextPaymentAmount {
                                await viewModel.makePayment(amount: nextAmt)
                            } else if viewModel.loan.outstandingBalance > 0 {
                                await viewModel.makePayment(amount: viewModel.loan.outstandingBalance)
                            }
                        }
                    }) {
                        if viewModel.isPaying {
                            ProgressView().tint(.white)
                        } else {
                            Text(viewModel.loan.nextPaymentAmount != nil ? "Make Payment" : (viewModel.loan.outstandingBalance > 0 ? "Payoff Balance" : "Done"))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .pilotButtonStyle(variant: .primary)
                    .disabled(viewModel.isPaying || viewModel.loan.outstandingBalance <= 0)
                    
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Payment Schedule")
                            .pilotTypography(.pilotHeadline)
                        
                        PilotCard {
                            VStack(spacing: 0) {
                                ForEach(viewModel.loan.paymentSchedule) { schedule in
                                    HStack {
                                        PilotIcon(name: schedule.isPaid ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(schedule.isPaid ? .pilotSuccess : .pilotSecondaryText)
                                        
                                        Text(schedule.dueDate, style: .date)
                                            .pilotTypography(.pilotBody, color: schedule.isPaid ? .pilotSecondaryText : .pilotPrimaryText)
                                        
                                        Spacer()
                                        
                                        Text("$\(String(format: "%.2f", schedule.amount))")
                                            .pilotTypography(.pilotBody, color: schedule.isPaid ? .pilotSecondaryText : .pilotPrimaryText)
                                    }
                                    .padding(.vertical, Spacing.sm)
                                    
                                    if schedule.id != viewModel.loan.paymentSchedule.last?.id {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .padding(Spacing.lg)
            }
        }
        .navigationTitle("Loan Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
