import SwiftUI

struct AutomationBuilderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Router<AutomationsRoute>.self) private var router
    @State private var viewModel: AutomationBuilderViewModel
    
    @State private var showingTriggerPicker = false
    @State private var showingActionPicker = false
    
    init(existingAutomation: Automation? = nil) {
        _viewModel = State(initialValue: AutomationBuilderViewModel(
            storage: DependencyContainer.shared.automationsStorage,
            automation: existingAutomation
        ))
    }
    
    var body: some View {
        ZStack {
            Color.pilotBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    summarySection
                    nameSection
                    triggersSection
                    actionsSection
                    
                    if !viewModel.isNew {
                        deleteSection
                    }
                }
                .padding(Spacing.lg)
            }
        }
        .navigationTitle(viewModel.isNew ? "New Automation" : "Edit Automation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    Task {
                        try? await viewModel.save()
                        dismiss()
                    }
                }
                .disabled(!viewModel.isValid)
            }
            
            if !viewModel.isNew {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Simulate") {
                        router.push(.simulation(id: viewModel.id))
                    }
                    .foregroundColor(.pilotAccent)
                }
            }
        }
        .sheet(isPresented: $showingTriggerPicker) {
            TriggerPickerView { selected in
                HapticsManager.shared.lightImpact()
                viewModel.triggers.append(selected)
                showingTriggerPicker = false
            }
        }
        .sheet(isPresented: $showingActionPicker) {
            ActionPickerView { selected in
                HapticsManager.shared.lightImpact()
                viewModel.actions.append(selected)
                showingActionPicker = false
            }
        }
    }
    
    @ViewBuilder
    private var summarySection: some View {
        PilotCard {
            Text(viewModel.summary)
                .pilotTypography(.pilotHeadline, color: .pilotAccent)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .animation(.default, value: viewModel.summary)
        }
    }
    
    @ViewBuilder
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("RULE NAME")
                .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
            
            TextField("e.g. Save Paycheck", text: $viewModel.name)
                .padding()
                .background(Color.pilotSurface)
                .cornerRadius(10)
        }
    }
    
    @ViewBuilder
    private var triggersSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("WHEN (Triggers)")
                .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
            
            ForEach(viewModel.triggers.indices, id: \.self) { index in
                HStack {
                    Text(viewModel.triggers[index].description)
                        .pilotTypography(.pilotBody)
                    Spacer()
                    Button(action: {
                        withAnimation { viewModel.triggers.remove(at: index) }
                    }) {
                        PilotIcon(name: "minus.circle.fill")
                            .foregroundColor(.pilotError)
                    }
                }
                .padding()
                .background(Color.pilotSurface)
                .cornerRadius(10)
            }
            
            Button(action: { showingTriggerPicker = true }) {
                HStack {
                    PilotIcon(name: "plus.circle.fill")
                    Text("Add Trigger")
                }
                .foregroundColor(.pilotAccent)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.pilotSurface)
                .cornerRadius(10)
            }
        }
    }
    
    @ViewBuilder
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("THEN (Actions)")
                .pilotTypography(.pilotCaption, color: .pilotSecondaryText)
            
            ForEach(viewModel.actions.indices, id: \.self) { index in
                HStack {
                    Text(viewModel.actions[index].description)
                        .pilotTypography(.pilotBody)
                    Spacer()
                    Button(action: {
                        withAnimation { viewModel.actions.remove(at: index) }
                    }) {
                        PilotIcon(name: "minus.circle.fill")
                            .foregroundColor(.pilotError)
                    }
                }
                .padding()
                .background(Color.pilotSurface)
                .cornerRadius(10)
            }
            
            Button(action: { showingActionPicker = true }) {
                HStack {
                    PilotIcon(name: "plus.circle.fill")
                    Text("Add Action")
                }
                .foregroundColor(.pilotSuccess)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.pilotSurface)
                .cornerRadius(10)
            }
        }
    }
    
    @ViewBuilder
    private var deleteSection: some View {
        Button(action: {
            Task {
                try? await DependencyContainer.shared.automationsStorage.delete(id: viewModel.id)
                dismiss()
            }
        }) {
            Text("Delete Automation")
                .foregroundColor(.pilotError)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pilotSurface)
                .cornerRadius(10)
        }
    }
}

// MARK: - Picker Subviews

struct TriggerPickerView: View {
    let onSelect: (Trigger) -> Void
    @Environment(\.dismiss) private var dismiss
    
    let triggers: [Trigger] = [
        .paycheckReceived(percentage: 0.1),
        .purchaseMade(category: nil),
        .recurringWeekly
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(triggers, id: \.description) { trigger in
                    Button(action: { onSelect(trigger) }) {
                        Text(trigger.description)
                            .foregroundColor(.pilotPrimaryText)
                    }
                }
            }
            .navigationTitle("Select Trigger")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct ActionPickerView: View {
    let onSelect: (Action) -> Void
    @Environment(\.dismiss) private var dismiss
    
    let actions: [Action] = [
        .transferToSavings(amount: 50, percentage: false),
        .transferToSavings(amount: 0.1, percentage: true),
        .roundUpPurchases,
        .sendNotification(message: "Money Moved!")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(actions, id: \.description) { action in
                    Button(action: { onSelect(action) }) {
                        Text(action.description)
                            .foregroundColor(.pilotPrimaryText)
                    }
                }
            }
            .navigationTitle("Select Action")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
