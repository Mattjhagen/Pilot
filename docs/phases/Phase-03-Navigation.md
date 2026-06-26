Phase 03 – Navigation

Status: Not Started

Dependencies:

* Phase 01 – Foundation
* Phase 02 – Design System

Architectural Impact:
High

⸻

Objective

Establish a cohesive and scalable navigation architecture for Pilot. Navigation is the backbone of the user experience; a clear structure keeps the app intuitive and reduces cognitive load. This phase will define how users move between core areas (Home, Money, Wealth, Trust, AI, Automations) and how deeper flows (e.g. details, modals) are managed. A well‑designed navigation system must be type‑safe, testable, and adaptive to all supported devices (iPhone, iPad, Mac Catalyst).

No financial functionality or AI logic should be added here. The goal is to create navigation scaffolding that can later host real features.

⸻

Read First

Review the Foundation and Design System implementations. Understand how themes, components and environment objects are set up. Look at Apple’s Navigation Stack and Navigation Split View patterns. Familiarize yourself with iOS, iPadOS and Mac navigation idioms, including tab bars, navigation bars, modals, sheets and split views. Study how deep linking works with NavigationPath and NavigationDestination.

⸻

Success Criteria

By the end of Phase 03:

• A centralized navigation coordinator or router exists that manages route enumeration and path state in a type‑safe manner.

• A bottom tab bar is implemented with icons and labels for the main sections: Home, Money, Wealth, Trust, AI, Automations. Each tab hosts its own NavigationStack using a custom Router or Coordinator.

• Navigation flows support pushing detail screens, popping back to previous screens, and presenting/dismissing modal sheets or full‑screen covers.

• A consistent approach to deep linking is defined: the app can navigate to specific content (e.g. a transaction detail) based on a URL or route identifier.

• Navigation adapts to device form factor: on iPad and Mac Catalyst, a NavigationSplitView displays a master list on the left and detail on the right when appropriate.

• Tabs use the Design System components (buttons, icons, typography) and respond to theme changes (light/dark, dynamic type).

• Haptic feedback and subtle animations accompany tab selection and navigation transitions.

• Navigation elements (tabs, buttons) are accessible with proper labels and support keyboard/pointer interactions.

• Unit tests verify that routers push and pop the correct routes and that modals appear and dismiss as expected.

• No placeholder financial data or network calls are introduced.

⸻

Required Architecture

The navigation system should be modular and testable. Use a NavigationRouter or FlowCoordinator pattern:

• Define an enum representing all possible routes within a feature (e.g. HomeRoute, MoneyRoute, TrustRoute). Each case corresponds to a destination view and may carry associated data.

• Create a Router class conforming to ObservableObject that holds a NavigationPath and provides methods like push(_:), pop(), popToRoot(), present(_:), and dismiss(). Expose the path as @Published so SwiftUI can react to changes.

• For each tab, instantiate its own router. Use dependency injection to provide routers to child views.

• Use NavigationStack on iPhone and NavigationSplitView on iPad/Mac Catalyst. Provide an adaptive container view that switches between stack and split view based on horizontal size class.

• Handle modal presentations through a separate state (e.g. @Published var sheet: SheetRoute?). Use SwiftUI’s .sheet(item:binding:) and .fullScreenCover(item:binding:) to present modals in a type‑safe way.

• Provide a deepLink(_:) method that interprets incoming URLs or notifications and pushes the appropriate route onto the correct router.

⸻

Build

1. Tab Bar: Using the Design System, build a bottom tab bar with six tabs: Home, Money, Wealth, Trust, AI, Automations. Each tab item includes an SF Symbol, a label and uses the color tokens defined in Phase 02. Highlight the active tab with a tint. Implement haptic feedback on selection.
2. Navigation Coordinator: Create a generic Router class that wraps a NavigationPath and SheetRoute state. Provide push/pop/dismiss functions. Create separate router instances for each tab feature.
3. Route Definitions: Define an enum for each major feature’s routes. For example, enum HomeRoute { case dashboard; case insightsDetail(id: UUID); case settings }. These will map to destination views.
4. Root Views: For each tab, create a root view (e.g. HomeView, MoneyView, WealthView, TrustView, AICopilotView, AutomationsView). For now, these should display placeholder content using the Design System (e.g. a card with “Home Screen Coming Soon”). Connect each root view to its router.
5. Navigation Stacks: Wrap each root view in a NavigationStack that binds to its router’s path. Use .navigationDestination(for:) to map each route case to a destination view. For example, navigationDestination(for: HomeRoute.self) { route in switch route { case .dashboard: HomeScreen(); case .insightsDetail(let id): InsightsDetailScreen(id: id); … }}.
6. Modal Presentation: Implement a generic sheet presentation mechanism. Define a SheetRoute enum (e.g. case settings, case newAutomation). Use .sheet(item:binding:) or .fullScreenCover(item:binding:) to present/dismiss modals based on router state.
7. Adaptive Layouts: Use @Environment(\.horizontalSizeClass) to determine when to switch to a split view. On iPad/Mac, wrap the tab’s navigation into a NavigationSplitView where the primary column lists top‑level items and the secondary column shows details. Provide fallback to NavigationStack on iPhone.
8. Deep Linking: Implement a handleDeepLink(_:) function in the app entry point. Parse URLs or notifications and translate them into route enums. Use the appropriate router’s push(_:) to navigate to the destination.
9. Preview Support: Add previews for the tab bar and navigation flows. Demonstrate transitions between routes and modals in SwiftUI’s canvas.
10. Accessibility: Ensure each tab item has an accessibilityLabel (e.g. “Home tab”, “Trust tab”). Provide accessibilityHint where needed. Support keyboard navigation by adding accessibilitySortPriority to control order.

⸻

Design Requirements

• The tab bar must integrate seamlessly with the Design System’s colors, fonts and spacing. Use subtle shadows or backgrounds as defined in Phase 02.

• Icons should be selected from SF Symbols and match the metaphors of each feature. For example, house.fill for Home, creditcard.fill for Money, chart.bar.xaxis for Wealth, shield.lefthalf.filled for Trust, bolt.horizontal.fill for AI, gearshape.2 for Automations.

• The navigation bars (titles) should be minimally styled—avoid large display titles unless absolutely necessary. Titles should reflect the current screen content.

• When using modals or sheets, respect Apple’s default presentation style and avoid custom transitions unless they provide real benefit. Use glass morphism backgrounds if appropriate.

• When pushing views onto the stack, use the Design System’s animation curves and haptic feedback patterns.

⸻

Performance

• Avoid holding heavyweight data in the navigation stack; keep route enums lightweight.

• Do not embed heavy computations in navigation actions. Offload heavy tasks to asynchronous functions outside the UI thread.

• Limit re‑renders by using @StateObject or @ObservedObject appropriately. Use @Published on router paths to trigger updates only when necessary.

⸻

Accessibility

• Provide accessibilityLabel, accessibilityHint and accessibilityIdentifier to tab items and buttons.

• Ensure that navigation elements are reachable via external keyboard and pointer. Add appropriate .focusable() modifiers where needed.

• Test with VoiceOver to ensure navigation flows announce screen changes and provide context (e.g. “You are on the Trust screen”).

• Respect Reduce Motion by using simpler transitions when the setting is enabled. Provide visual alternatives (e.g. fade instead of slide) if necessary.

⸻

Testing

• Unit Tests: Write tests for the router to ensure push/pop operations modify the navigation path correctly. Test deep link handling to verify that specific URLs translate to the expected route.

• Snapshot Tests: Verify the tab bar appears correctly in light/dark mode and across different device sizes.

• UI Tests: Use XCTest to simulate user interaction, such as selecting tabs, pushing to a detail view and dismissing modals. Ensure navigation flows work under multiple scenarios.

⸻

Documentation

Document the navigation architecture in /docs/architecture/Navigation.md:

• Explain the router/coordinator pattern, route enums and how navigation paths work.

• Describe how to add a new tab or route.

• Provide examples of deep linking and modal presentation.

• Explain adaptation for iPad and Mac Catalyst.

Record all major decisions (e.g. choice of router pattern, use of NavigationStack vs NavigationSplitView) in DECISIONS.md.

⸻

Completion

When this phase is complete:

• Run the app across supported devices (iPhone, iPad, Mac). Verify that the tab bar and navigation flows behave consistently. Test dynamic type, dark mode, and accessibility settings.

• Summarize the navigation architecture, including route definitions and coordinators. Identify areas for improvement or further refactoring.

• Update DECISIONS.md with architectural choices made.

After summarizing and documenting, do not begin Phase 04. Wait for review and approval.

⸻

Do not begin the next phase, even if you believe there is remaining context. Your job is to complete only this phase, verify it builds cleanly, update DECISIONS.md with any architectural decisions, summarize the work performed, and wait for further instructions.
