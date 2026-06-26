• Automation: struct with properties: id, name, triggers: [Trigger], conditions: [Condition], actions: [Action], isEnabled: Bool, createdDate, and optional schedule for time‑based triggers. Include a computed property to generate a human‑readable summary.

• Trigger: enum representing events that can start an automation. Cases include:

* .paycheckReceived(percentage: Double)
* .purchaseMade(category: TransactionCategory?)
* .balanceAbove(amount: Decimal)
* .balanceBelow(amount: Decimal)
* .dayOfMonth(Int)
* .dayOfWeek(weekday: Int)
* .recurring(interval: TimeInterval)

Each case can hold associated values. Provide a method to describe the trigger in plain language (“when my balance goes above $3,000”).

• Condition: enum with cases such as:

* .balanceGreaterThan(amount: Decimal)
* .balanceLessThan(amount: Decimal)
* .categoryEquals(TransactionCategory)
* .trustScoreAbove(Double)
* .trustScoreBelow(Double)
* .dayIsWeekend(Bool)
* .timeIsBetween(start: Time, end: Time)

Conditions refine when an action executes. Provide descriptions for UI.

• Action: enum representing what the automation does. Cases include:

* .transferToSavings(amount: Decimal, percentage: Bool)
* .invest(amount: Decimal, percentage: Bool)
* .pauseSubscription(id: String)
* .sendNotification(message: String)
* .roundUpPurchases()
* .moveExcessToSavings(threshold: Decimal)

Actions should include displayable names and summarization logic.

• AutomationsStorageService: a class to persist automations locally (e.g. using SwiftData). Provide methods: fetchAll(), create(automation:), update(automation:), delete(id:), toggle(id:). Keep the service agnostic of UI.

• AutomationMockRunner: a service that accepts an Automation and sample data (accounts, transactions) and simulates its effect over a chosen period. Return a result summary (total saved, invested, etc.) for display in the simulation view. Use asynchronous execution if the simulation is heavy.

• AutomationsOverviewViewModel: manages the list of automations, handles toggles, deletion and navigation to builder/detail screens.

• AutomationBuilderViewModel: guides the creation of an automation. Holds temporary state for name, triggers, conditions and actions. Validates inputs and generates a natural‑language summary. Provides functions to append triggers/conditions/actions and to remove them.

• AutomationDetailViewModel: similar to builder but for editing an existing automation. It can also run simulations via AutomationMockRunner.

⸻

Build

1. Define Models and Enums: Create Automation, Trigger, Condition and Action structs/enums with associated values and helper functions to describe them in natural language. Provide example triggers, conditions and actions to use in previews.
2. Implement Storage Service: Build AutomationsStorageService to load and save automations. Use SwiftData or FileManager under the hood. Ensure thread safety and handle serialization gracefully. Write tests for CRUD operations.
3. Overview Screen: Implement AutomationsOverviewView that lists automations using AutomationCardView. Each card displays the name, summary and a toggle. Provide a “+” button in the navigation bar. Show an empty state placeholder when no automations exist (“No automations yet. Tap + to create your first rule.”). When a card is tapped, navigate to an edit screen (AutomationBuilderView prepopulated with the rule).
4. Builder UI: Build AutomationBuilderView as a multi‑step form or a single page with collapsible sections:
    * Name: text field for naming the automation.
    * Triggers Section: list current triggers with the ability to add a new one via TriggerPickerView. Use a modal or sheet to present available triggers and their parameters (e.g. slider for percentage). Support multiple triggers; display them in a list with deletion and reordering.
    * Conditions Section: optional; similar to triggers. Present conditions via ConditionPickerView and list them.
    * Actions Section: list of selected actions. Use ActionPickerView to choose actions and specify amounts or percentages. Support multiple actions per rule.
    * Summary: show a live, natural‑language summary of the rule using the state of the builder. Update as the user edits triggers/conditions/actions.
    * Save: a button to validate and persist the automation via the storage service. Offer a preview before saving.
5. Editing and Deleting: In AutomationDetailView, allow editing the rule using the builder view. Provide a delete button that removes the automation from storage. Use a confirmation alert before deletion.
6. Simulation: In AutomationDetailView, provide a “Test Run” button. When tapped, use AutomationMockRunner to simulate the automation using sample data from MoneyMockService. Show results in AutomationSimulationView: a summary of the actions (e.g. “Would have saved $180 in the last three months”), a simple chart or timeline of when actions would have occurred, and a breakdown by action type. Make clear that this is a simulation.
7. Templates: Offer a few quick‑start templates in the builder: e.g. “Save 10% of each paycheck”, “Round up purchases”, “Invest $50 every Friday”. When selected, prefill the builder with corresponding triggers, conditions and actions. Users can review and customize the template before saving.
8. Usability and Haptics: Use the Design System’s components to ensure consistency. Provide haptic feedback when adding/removing triggers, conditions or actions. Use animations when expanding or collapsing sections. Display validation errors when fields are incomplete (“Please choose at least one trigger and one action.”).
9. Accessibility: For each trigger, condition and action, provide clear labels and hints explaining what they do. The summary should be readable by screen readers. Buttons and toggles must be accessible. Follow dynamic type and high‑contrast guidelines.
10. Localization: Prepare strings for localization, especially for natural‑language summaries. Use LocalizedStringKey to ensure text adapts to the user’s locale. Format currency and dates appropriately.
11. Tests and Previews: Add previews for the builder, overview and simulation screens in light and dark modes with various dynamic type sizes. Write unit tests to ensure the builder view model creates valid automation objects and rejects invalid ones. Write tests for the storage service and simulation runner. Use UI tests to simulate creating, editing, toggling and deleting automations.

⸻

Design Requirements

• Visual Flow: Organize the builder into clear sections. Use cards, stepper or collapsible sections to avoid overwhelming the user. Provide progress indicators if using a multi‑step approach.

• Natural Language: The automation summary should read naturally (“When my checking account drops below $500 and it’s after rent day, send me a warning notification.”). Use plain language and avoid jargon.

• Color Coding: Use the Design System’s color palette to differentiate triggers (e.g. blue), conditions (yellow/orange) and actions (green). Provide icons for each element (e.g. calendar for day triggers, bell for notifications, piggy bank for savings).

• Clarity: Use clear descriptions for triggers and actions (e.g. “Round up purchases to the nearest dollar and move the difference to Savings”) so users understand what will happen.

• Safety: Label simulated actions clearly. If an action would normally move money or pause a subscription, indicate that it is a simulation and actual actions will be configured later. Never imply that a real transfer will occur without explicit user confirmation in future phases.

⸻

Performance

• Persist automations efficiently. Do not recompute natural‑language summaries unless underlying data changes. Cache summaries if necessary.

• Simulations should run on a background queue and update the UI on the main thread. For complex simulations, throttle updates.

• When listing automations, avoid computing heavy summaries in the body. Precompute them in the view model.

⸻

Accessibility

• Provide descriptive VoiceOver labels for triggers, conditions and actions. For example, “Trigger: paycheck received, saves ten percent”.

• Summaries should be accessible as a single element with a clear description. Avoid splitting them into multiple unlabeled elements.

• Use large hit areas for interactive elements. Support external keyboard navigation for the builder forms.

• Respect “Reduce Motion” by simplifying animations when enabled.

⸻

Testing

• Unit Tests: Test that AutomationBuilderViewModel produces a valid Automation with correct triggers, conditions and actions. Verify the AutomationsStorageService correctly saves, updates and deletes automations. Test AutomationMockRunner with sample automations and data; ensure it returns expected results.

• Snapshot Tests: Capture the builder UI in initial, mid‑build and summary states across light and dark modes. Capture the overview list with multiple automations and with no automations.

• UI Tests: Simulate creating an automation, editing an existing one, toggling it on/off and deleting it. Verify that validation errors appear when expected and that the simulation view displays results.

⸻

Documentation

Create a new file /docs/architecture/Automations.md:

• Outline the rule model (triggers, conditions, actions) and how they combine into an automation.

• Explain the storage mechanism, including how automations are persisted and retrieved.

• Describe the simulation runner and how it uses mock data. Provide examples of simulation results.

• Give guidelines for adding new triggers, conditions or actions (e.g. new transaction types, new scheduling options).

Add entries to DECISIONS.md explaining why the rule builder uses a specific UI pattern, how triggers and conditions are prioritized, and how natural‑language summaries are constructed.

⸻

Completion

When this phase is complete:

• Run the app and create several automations using mock data. Test enabling, disabling, editing and deleting them. Ensure that the simulation results make sense and that the UI remains consistent.

• Summarize the implementation: what triggers, conditions and actions were supported; how the UI behaves; and any limitations or future improvements (e.g. scheduling edge cases, performance for large simulations).

• Update DECISIONS.md with important architectural and UX decisions made during this phase.

After summarizing and documenting, do not begin Phase 09. Wait for review and approval.

⸻

Do not begin the next phase, even if you believe there is remaining context. Your job is to complete only this phase, verify it builds cleanly, update DECISIONS.md with any architectural decisions, summarize the work performed, and wait for further instructions.
