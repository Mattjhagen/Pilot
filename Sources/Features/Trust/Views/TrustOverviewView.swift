import SwiftUI

struct TrustOverviewView: View {
    @Environment(Router<TrustRoute>.self) private var router
    @State private var viewModel: TrustOverviewViewModel
    
    init() {
        _viewModel = State(initialValue: TrustOverviewViewModel(service: DependencyContainer.shared.trustService))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    if viewModel.isLoading && viewModel.metrics.isEmpty {
                        ProgressView()
                            .padding(.top, Spacing.xxl)
                    } else {
                        scoreSection
                        metricsSection
                        suggestionsSection
                        verificationSection
                    }
                }
                .padding(Spacing.lg)
            }
            .refreshable {
                HapticsManager.shared.lightImpact()
                await viewModel.loadData()
            }
        }
        .navigationTitle("Trust")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.metrics.isEmpty {
                await viewModel.loadData()
            }
        }
        .navigationDestination(for: TrustRoute.self) { route in
            switch route {
            case .metricDetail(let metricId):
                if let metric = viewModel.metrics.first(where: { $0.id == metricId }) {
                    TrustDetailView(metric: metric)
                } else {
                    Text("Metric not found")
                }
            case .identityVerification:
                IdentityVerificationView()
            }
        }
    }
    
    @ViewBuilder
    private var scoreSection: some View {
        if let score = viewModel.overallScore {
            TrustScoreCard(score: score)
        }
    }
    
    @ViewBuilder
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Score Breakdown")
                .pilotTypography(.pilotHeadline)
            
            LazyVStack(spacing: Spacing.md) {
                ForEach(viewModel.metrics) { metric in
                    PilotCard {
                        HStack(spacing: Spacing.md) {
                            PilotIcon(name: metric.iconName)
                                .foregroundColor(.pilotAccent)
                                .font(.system(size: 24))
                                .frame(width: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(metric.name)
                                    .pilotTypography(.pilotBody)
                                
                                HStack {
                                    Text("\(metric.currentValue)/\(metric.maxValue)")
                                        .pilotTypography(.pilotFootnote, color: .pilotSecondaryText)
                                    
                                    if metric.trend != 0 {
                                        Text(metric.trend > 0 ? "+\(metric.trend)" : "\(metric.trend)")
                                            .pilotTypography(.pilotFootnote, color: metric.trend > 0 ? .pilotSuccess : .pilotError)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            PilotIcon(name: "chevron.right")
                                .foregroundColor(.pilotSecondaryText)
                                .font(.system(size: 14))
                        }
                    }
                    .onTapGesture {
                        router.push(.metricDetail(id: metric.id))
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(metric.name): \(metric.currentValue) out of \(metric.maxValue)")
                }
            }
        }
    }
    
    @ViewBuilder
    private var suggestionsSection: some View {
        if !viewModel.suggestions.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("Ways to Improve")
                    .pilotTypography(.pilotHeadline)
                
                ForEach(viewModel.suggestions) { suggestion in
                    PilotCard {
                        HStack(alignment: .top, spacing: Spacing.md) {
                            PilotIcon(name: "lightbulb.fill", weight: .semibold)
                                .foregroundColor(.pilotWarning)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(suggestion.title)
                                    .pilotTypography(.pilotBody)
                                Text(suggestion.message)
                                    .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var verificationSection: some View {
        PilotCard {
            HStack(spacing: Spacing.md) {
                PilotIcon(name: "person.text.rectangle", weight: .semibold)
                    .foregroundColor(.pilotAccent)
                    .font(.system(size: 30))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Verify Identity")
                        .pilotTypography(.pilotBody)
                    Text("Boost your score by proving who you are.")
                        .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
                }
                
                Spacer()
                
                Button(action: {
                    router.push(.identityVerification)
                }) {
                    Text("Start")
                }
                .pilotButtonStyle(variant: .secondary)
            }
        }
    }
}
