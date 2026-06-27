import SwiftUI

struct AutomationsOverviewView: View {
    @Environment(Router<AutomationsRoute>.self) private var router
    @State private var viewModel: AutomationsOverviewViewModel
    
    init() {
        _viewModel = State(initialValue: AutomationsOverviewViewModel(storage: DependencyContainer.shared.automationsStorage))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            if viewModel.isLoading && viewModel.automations.isEmpty {
                ProgressView()
            } else if viewModel.automations.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: Spacing.md) {
                        ForEach(viewModel.automations) { automation in
                            AutomationCardView(automation: automation) {
                                Task { await viewModel.toggleAutomation(id: automation.id) }
                            }
                            .onTapGesture {
                                router.push(.detail(id: automation.id))
                            }
                        }
                    }
                    .padding(Spacing.lg)
                }
                .refreshable {
                    HapticsManager.shared.lightImpact()
                    await viewModel.loadAutomations()
                }
            }
        }
        .navigationTitle("Automations")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    router.push(.builder)
                } label: {
                    PilotIcon(name: "plus", weight: .semibold)
                        .foregroundColor(.pilotAccent)
                }
            }
        }
        .task {
            if viewModel.automations.isEmpty {
                await viewModel.loadAutomations()
            }
        }
        .navigationDestination(for: AutomationsRoute.self) { route in
            switch route {
            case .builder:
                AutomationBuilderView()
            case .detail(let id):
                if let auto = viewModel.automations.first(where: { $0.id == id }) {
                    AutomationBuilderView(existingAutomation: auto)
                } else {
                    Text("Automation not found")
                }
            case .simulation(let id):
                if let auto = viewModel.automations.first(where: { $0.id == id }) {
                    AutomationSimulationView(automation: auto)
                } else {
                    Text("Automation not found")
                }
            }
        }
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            PilotIcon(name: "bolt.horizontal.circle.fill", weight: .light)
                .font(.system(size: 80))
                .foregroundColor(.pilotSecondaryText)
            
            Text("No automations yet")
                .pilotTypography(.pilotTitle)
            
            Text("Tap + to create your first rule.")
                .pilotTypography(.pilotBody, color: .pilotSecondaryText)
        }
    }
}

struct AutomationCardView: View {
    let automation: Automation
    let onToggle: () -> Void
    
    var body: some View {
        PilotCard {
            HStack(alignment: .top, spacing: Spacing.md) {
                PilotIcon(name: "bolt.fill")
                    .foregroundColor(automation.isEnabled ? .pilotAccent : .pilotSecondaryText)
                    .font(.system(size: 24))
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(automation.name)
                        .pilotTypography(.pilotHeadline, color: automation.isEnabled ? .pilotPrimaryText : .pilotSecondaryText)
                    
                    Text(automation.generatedSummary)
                        .pilotTypography(.pilotFootnote, color: .pilotSecondaryText)
                }
                
                Spacer()
                
                // Native SwiftUI toggle
                Toggle("", isOn: Binding(
                    get: { automation.isEnabled },
                    set: { _ in onToggle() }
                ))
                .labelsHidden()
                .tint(.pilotAccent)
            }
        }
        .opacity(automation.isEnabled ? 1.0 : 0.6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(automation.name). \(automation.generatedSummary). \(automation.isEnabled ? "Enabled" : "Disabled")")
        .accessibilityAction(named: automation.isEnabled ? "Disable" : "Enable") {
            onToggle()
        }
    }
}
