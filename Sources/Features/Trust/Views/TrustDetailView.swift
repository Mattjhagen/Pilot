import SwiftUI
import Charts

struct TrustDetailView: View {
    let metric: TrustMetric
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    headerSection
                    chartSection
                    tipsSection
                }
                .padding(Spacing.lg)
            }
        }
        .navigationTitle(metric.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var headerSection: some View {
        PilotCard {
            VStack(spacing: Spacing.md) {
                PilotIcon(name: metric.iconName, weight: .regular)
                    .font(.system(size: 40))
                    .foregroundColor(.pilotAccent)
                
                Text("\(metric.currentValue) / \(metric.maxValue)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.pilotPrimaryText)
                
                Text(metric.description)
                    .pilotTypography(.pilotBody, color: .pilotSecondaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("6-Month History")
                .pilotTypography(.pilotHeadline)
            
            PilotCard {
                Chart(metric.history) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Score", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.pilotAccent)
                    
                    AreaMark(
                        x: .value("Date", point.date),
                        y: .value("Score", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pilotAccent.opacity(0.3), Color.pilotAccent.opacity(0.0)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .chartYScale(domain: 0...100)
                .frame(height: 200)
            }
        }
    }
    
    @ViewBuilder
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("How to Improve")
                .pilotTypography(.pilotHeadline)
            
            PilotCard {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        PilotIcon(name: "checkmark.circle.fill")
                            .foregroundColor(.pilotSuccess)
                        Text("Consistently maintain positive cash flow to demonstrate reliability.")
                            .pilotTypography(.pilotBody)
                    }
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        PilotIcon(name: "checkmark.circle.fill")
                            .foregroundColor(.pilotSuccess)
                        Text("Avoid frequent large withdrawals that drop your balance near zero.")
                            .pilotTypography(.pilotBody)
                    }
                }
            }
        }
    }
}
