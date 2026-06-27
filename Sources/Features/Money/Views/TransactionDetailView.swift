import SwiftUI

struct TransactionDetailView: View {
    let transaction: Transaction
    @State private var showActionAlert = false
    @State private var actionName = ""
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    headerSection
                    detailsSection
                    actionsSection
                }
                .padding(Spacing.lg)
            }
        }
        .navigationTitle("Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Coming Soon", isPresented: $showActionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(actionName) is simulated.")
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: Spacing.md) {
            PilotIcon(name: transaction.category.iconName, weight: .regular)
                .font(.system(size: 40))
                .foregroundColor(.pilotSecondaryText)
                .frame(width: 80, height: 80)
                .background(Color.pilotSurface)
                .clipShape(Circle())
            
            Text(transaction.merchant ?? transaction.description)
                .pilotTypography(.pilotTitle)
                .multilineTextAlignment(.center)
            
            Text("\(transaction.amount > 0 ? "+" : "")$\(String(format: "%.2f", abs(transaction.amount)))")
                .pilotTypography(.pilotLargeTitle, color: transaction.amount > 0 ? .pilotSuccess : .pilotPrimaryText)
        }
    }
    
    @ViewBuilder
    private var detailsSection: some View {
        PilotCard {
            VStack(spacing: 0) {
                detailRow(title: "Status", value: transaction.status.rawValue)
                Divider().padding(.vertical, Spacing.sm)
                detailRow(title: "Date", value: transaction.date.formatted(date: .abbreviated, time: .shortened))
                Divider().padding(.vertical, Spacing.sm)
                detailRow(title: "Category", value: transaction.category.rawValue)
            }
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .pilotTypography(.pilotBody, color: .pilotSecondaryText)
            Spacer()
            Text(value)
                .pilotTypography(.pilotBody)
        }
    }
    
    @ViewBuilder
    private var actionsSection: some View {
        VStack(spacing: Spacing.md) {
            Button(action: {
                actionName = "Add Receipt"
                showActionAlert = true
            }) {
                Text("Add Receipt")
                    .frame(maxWidth: .infinity)
            }
            .pilotButtonStyle(variant: .secondary)
            
            Button(action: {
                actionName = "Dispute Transaction"
                showActionAlert = true
            }) {
                Text("Dispute Transaction")
                    .frame(maxWidth: .infinity)
            }
            .pilotButtonStyle(variant: .secondary)
        }
    }
}
