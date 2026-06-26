• Models: Simple structs representing each section’s data. Include sample static data or a generator method. Keep models decoupled from UI.

• ViewModel: HomeDashboardViewModel orchestrates the various models and provides published properties for the view. It controls the refresh logic and may randomize sample data on refresh.

• Services: HomeMockService can provide mock data generation. Keep this separate so real services can replace it later.

• Views: Each card is a reusable View configured with a model. Card views should not fetch data themselves. Compose them in HomeDashboardView using LazyVStack or Grid.

• Use dependency injection to inject the mock service into the view model. Use the DI container from Phase 01.

⸻

Build

1. Models and Service: Define the models (Bill, Transaction, etc.) with sample data. Implement HomeMockService that returns arrays of sample bills, transactions, subscriptions, etc. Provide randomization where appropriate.
2. ViewModel: Implement HomeDashboardViewModel that, on init, loads mock data via the service and exposes published properties (e.g. [Bill], [Transaction], TrustScore). Provide a refresh() method that regenerates data with a delay.
3. Card Views: Build each card as a separate SwiftUI view using the Design System. Use the spacing, color, typography tokens. For lists inside cards (e.g. upcoming bills), use VStack or ForEach. For progress bars or radial gauges, rely on SwiftUI’s ProgressView or build a custom gauge component if necessary. Provide tappable areas on cards to prepare for future navigation; currently these should just print to the console or show a placeholder alert.
4. Quick Actions Row: Implement a horizontal ScrollView or LazyHStack of buttons for quick actions. Use icons and labels from the Design System. Provide haptic feedback on tap.
5. Compose HomeDashboardView: Create HomeDashboardView that arranges all cards in a ScrollView. Use LazyVStack for vertical stacking. Optionally group related cards into sections with headers. Add .refreshable { await viewModel.refresh() } to allow pull‑to‑refresh.
6. Placeholder Live Activity: Reserve a small, collapsible area below the navigation bar for a Live Activity preview. Insert a placeholder view with a simple progress indicator or icon. Document how this area could be used in Phase 09 for real Live Activities.
7. Previews and Snapshots: Add PreviewProviders for each card and the full dashboard. Show how the dashboard looks in light and dark mode, with large and small dynamic type sizes.
8. Testing: Implement basic unit tests for HomeDashboardViewModel ensuring sample data is loaded and refreshed correctly. Use snapshot tests to verify that card layouts do not change unexpectedly.

⸻

Design Requirements

• Clarity and Hierarchy: The most critical information (available money, upcoming bills) should appear near the top of the dashboard and use larger typography. Less critical sections (recent activity, AI insights feed) can be lower down or collapsible.

• Compact Cards: Avoid charts for the sake of decoration. Only include visuals when they answer a question (e.g. a progress ring showing savings progress). Keep cards compact but allow content to expand if necessary.

• Adaptive Layout: Use one column layout on narrow screens and two columns on larger screens (e.g. iPad in landscape). Respect safe areas and avoid content touching edges.

• Movement: Use subtle motion when cards appear or refresh (e.g. fade/slide). Use spring animations consistent with the Design System. Provide haptic feedback on refresh and when tapping quick actions.

• Readable Text: Ensure text size and line spacing make reading easy. Do not cram content. Use our typographic scale.

• Visually Distinct Sections: Separate cards with spacing. Optionally use faint dividers or section headers to group related information.

⸻

Performance

• Use LazyVStack and LazyHStack to avoid preloading off‑screen views.

• Ensure that card views are lightweight. Avoid heavy view calculations inside the body; precompute any needed values in the view model.

• Do not embed NavigationStack or other stateful containers inside cards.

• When generating mock data, avoid blocking the main thread. Use Task {} with small delays for simulation.

⸻

Accessibility

• All cards must have accessibilityElement(children: .contain) and an appropriate accessibilityLabel describing the summary (e.g. “Upcoming bills: 3 bills totaling $250 due next week”).

• Quick action buttons must have accessibilityLabel (e.g. “Pay a Bill”) and use accessibilityHint to describe what will happen.

• Use accessibilitySection to group related cards.

• Ensure progress indicators and gauges provide descriptions for VoiceOver (e.g. “Savings goal is 30% complete”).

• Respect user settings: dynamic type, high contrast, VoiceOver, Reduce Motion.

⸻

Testing

• Unit Tests: Test HomeDashboardViewModel.refresh() to ensure it updates models and triggers UI refresh.

• Snapshot Tests: Capture the dashboard in light/dark modes and with different dynamic type settings to detect visual regressions.

• UI Tests: Simulate a user pulling to refresh, tapping quick actions and scrolling through the dashboard. Verify that accessibility labels are present and correct.

⸻

Documentation

Document the dashboard architecture in /docs/architecture/Dashboard.md:

• Describe the purpose of each card and how it maps to a model.

• Explain how the view model handles data and refresh logic.

• Include sample code for adding a new card or modifying existing ones.

• Discuss how Live Activities could be integrated in Phase 09.

Record any significant architectural choices in DECISIONS.md (e.g. why you chose a single scroll view vs. multiple sections, or how you handled grid layouts on iPad).

⸻

Completion

When this phase is complete:

• Run the app on multiple devices and verify that the dashboard looks correct, adapts to settings and displays mock data.

• Summarize the implemented dashboard, components and any issues found. Identify improvements for later phases (e.g. more flexible grid layouts).

• Update DECISIONS.md with architectural decisions made during implementation.

After summarizing and documenting, do not begin Phase 05. Wait for review and approval.

⸻

Do not begin the next phase, even if you believe there is remaining context. Your job is to complete only this phase, verify it builds cleanly, update DECISIONS.md with any architectural decisions, summarize the work performed, and wait for further instructions.
