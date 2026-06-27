import SwiftUI

struct AvailableMoneyCard: View {
    let data: AvailableMoney?
    
    var body: some View {
        PilotCard(hasGlassmorphism: false) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Available Money")
                    .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                
                if let data = data {
                    Text("\(data.currencySymbol)\(String(format: "%.2f", data.amount))")
                        .pilotTypography(.pilotLargeTitle)
                    
                    Text(data.description)
                        .pilotTypography(.pilotFootnote, color: .pilotSuccess)
                } else {
                    ProgressView()
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Available Money: \(data != nil ? "\(data!.currencySymbol)\(String(format: "%.2f", data!.amount))" : "Loading")")
    }
}

struct QuickActionsRow: View {
    let actions: [QuickAction]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Spacing.md) {
                ForEach(actions) { action in
                    Button(action: {
                        HapticsManager.shared.lightImpact()
                        print("Tapped action: \(action.title)")
                    }) {
                        VStack(spacing: Spacing.xs) {
                            PilotIcon(name: action.iconName, weight: .semibold)
                                .font(.system(size: 24))
                                .foregroundColor(.pilotAccent)
                                .frame(width: 50, height: 50)
                                .background(Color.pilotAccent.opacity(0.1))
                                .clipShape(Circle())
                            
                            Text(action.title)
                                .pilotTypography(.pilotCaption, color: .pilotPrimaryText)
                        }
                    }
                    .accessibilityLabel(action.title)
                    .accessibilityHint("Quick action")
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
}

struct UpcomingBillsCard: View {
    let bills: [UpcomingBill]
    
    var body: some View {
        PilotCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("Upcoming Bills")
                    .pilotTypography(.pilotHeadline)
                
                if bills.isEmpty {
                    Text("No upcoming bills")
                        .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                } else {
                    ForEach(bills) { bill in
                        HStack {
                            Text(bill.title)
                                .pilotTypography(.pilotBody)
                            Spacer()
                            Text("$\(String(format: "%.2f", bill.amount))")
                                .pilotTypography(.pilotBody, color: .pilotError)
                        }
                    }
                }
            }
        }
    }
}

struct RecentSpendingCard: View {
    let transactions: [RecentTransaction]
    
    var body: some View {
        PilotCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("Recent Spending")
                    .pilotTypography(.pilotHeadline)
                
                if transactions.isEmpty {
                    Text("No recent transactions")
                        .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                } else {
                    ForEach(transactions.prefix(3)) { t in
                        HStack {
                            Text(t.merchant)
                                .pilotTypography(.pilotBody)
                            Spacer()
                            Text("\(t.isIncome ? "+" : "-") $\(String(format: "%.2f", t.amount))")
                                .pilotTypography(.pilotBody, color: t.isIncome ? .pilotSuccess : .pilotPrimaryText)
                        }
                    }
                }
            }
        }
    }
}

struct TrustScoreCard: View {
    let score: TrustScore?
    
    var body: some View {
        PilotCard {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Trust Score")
                    .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                
                if let score = score {
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(score.score)")
                            .pilotTypography(.pilotTitle)
                            .foregroundColor(.pilotSuccess)
                        Text("/ \(score.maxScore)")
                            .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                    }
                    Text(score.category)
                        .pilotTypography(.pilotFootnote, color: .pilotSuccess)
                } else {
                    ProgressView()
                }
            }
        }
    }
}

struct AIInsightsCard: View {
    let insights: [AIInsight]
    
    var body: some View {
        if !insights.isEmpty {
            PilotCard {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    HStack {
                        PilotIcon(name: "bolt.horizontal.fill", weight: .bold)
                            .foregroundColor(.pilotAccent)
                        Text("AI Insights")
                            .pilotTypography(.pilotHeadline)
                    }
                    
                    ForEach(insights) { insight in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(insight.title)
                                .pilotTypography(.pilotBody)
                            Text(insight.message)
                                .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                        }
                        .padding(.vertical, Spacing.xs)
                    }
                }
            }
        }
    }
}

struct LiveActivityPlaceholder: View {
    var body: some View {
        VStack {
            Text("Active Ride or Order")
                .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
            HStack {
                PilotIcon(name: "car.fill")
                ProgressView()
                Spacer()
                Text("Arriving in 3 min")
                    .pilotTypography(.pilotCaption)
            }
        }
        .padding(Spacing.sm)
        .background(GlassView(cornerRadius: 12))
        .padding(.horizontal, Spacing.lg)
    }
}
