DECISIONS.md

Pilot Architectural Decision Record (ADR)

This document preserves the reasoning behind major architectural decisions.

It is not a changelog.

It is not a commit history.

It exists to explain why important decisions were made so future contributors (human or AI) understand the intent behind the architecture.

⸻

Rules

Whenever a decision significantly affects:

* architecture
* data models
* navigation
* persistence
* networking
* AI behavior
* security
* performance
* dependencies
* project organization

append a new ADR entry.

Do not rewrite previous decisions.

If a decision changes, create a new entry explaining why the previous decision was superseded.

Historical context is valuable.

⸻

Entry Format

⸻

ADR-000

Date

YYYY-MM-DD

Status

Accepted

Superseded

Deprecated

Experimental

Decision

A concise summary of the decision.

Context

What problem were we trying to solve?

What constraints existed?

Why was this decision necessary?

Alternatives Considered

List the realistic alternatives.

Explain why they were rejected.

Decision

Describe the chosen solution.

Avoid implementation details.

Focus on architecture.

Consequences

Positive outcomes.

Tradeoffs.

Future implications.

Implementation Notes

Optional.

Useful implementation guidance.

⸻

ADR-001

Date

2026-06-26

Status

Accepted

Decision

Pilot is an AI Financial Operating System rather than a traditional banking application.

Context

The original P3 project focused primarily on lending.

During planning it became clear that lending represents only one aspect of a person’s financial life.

Building a broader operating system allows lending to become a capability rather than the primary product.

Alternatives Considered

• Continue building only a lending platform.

• Build a traditional neobank.

• Focus exclusively on investing.

Decision

Pilot will become the intelligence layer connecting every aspect of a user’s financial life.

Banking, investing, lending, savings, automation, trust scoring, and AI assistance all exist under one unified experience.

Consequences

Positive

• Larger product vision

• Greater long-term differentiation

• Easier future expansion

Tradeoffs

• Increased architectural complexity

• Broader product scope

Implementation Notes

All future modules should assume they are components within a financial operating system rather than standalone products.

⸻

ADR-002

Date

2026-06-26

Status

Accepted

Decision

Adopt a native Apple-first architecture.

Context

Pilot is intended to feel like a first-party Apple application.

Consistency, accessibility, and long-term maintainability outweigh cross-platform abstraction.

Alternatives Considered

UIKit

React Native

Flutter

Compose Multiplatform

Decision

Use:

SwiftUI

SwiftData

Observation

Async/Await

Structured Concurrency

Native Apple frameworks whenever possible.

Consequences

Positive

• Native performance

• Better accessibility

• Lower maintenance

• Excellent Apple ecosystem integration

Tradeoffs

• Apple-only implementation

Implementation Notes

Avoid introducing third-party UI frameworks unless a compelling technical reason exists.

⸻

ADR-003

Date

2026-06-26

Status

Accepted

Decision

AI should be proactive instead of reactive.

Context

Most financial applications require users to discover insights themselves.

Pilot should reduce cognitive load by surfacing important information automatically.

Alternatives Considered

Traditional chatbot

Search interface

Manual reports

Decision

The AI should notice patterns, identify risks, recommend actions, and automate repetitive financial tasks whenever appropriate.

Consequences

Positive

Creates a product that feels substantially different from existing fintech applications.

Tradeoffs

Requires stronger notification, prioritization, and personalization systems.

⸻

Future Decisions

Examples of decisions that belong here include:

• Authentication architecture

• Offline-first strategy

• Financial institution aggregation provider

• AI provider selection

• Encryption model

• Data synchronization

• Trust Score calculation

• Lending architecture

• Widget architecture

• Plugin system

• Automation engine

• Notification framework

• Performance optimizations

• Modularization strategy

• Cross-device synchronization

If a future developer wonders “Why was this designed this way?”, the answer should be in this document—not buried in Git history.

⸻

ADR-004

Date

2026-06-26

Status

Accepted

Decision

Use XcodeGen for project generation instead of committing `.xcodeproj`.

Context

Committing `.xcodeproj` files frequently leads to merge conflicts, particularly as the team scales or when adding/removing many files. We needed a clean, reproducible way to manage the Xcode project structure.

Alternatives Considered

• Maintain standard `.xcodeproj` in Git
• Swift Package Manager (SPM) only
• Tuist

Decision

Adopt `XcodeGen` to generate the `.xcodeproj` file dynamically from `project.yml`. The project file will be ignored in Git, ensuring clean, conflict-free merges and PRs.

Consequences

Positive
• No project file merge conflicts
• Simple, readable declarative configuration (`project.yml`)

Tradeoffs
• Requires developers to have `xcodegen` installed and run it after checking out.

⸻

ADR-006

Date

2026-06-26

Status

Accepted

Decision

Adopt a flat, top-level grouping architecture for the `Sources` directory.

Context

The initial `Sources` folder structure was deeply nested (e.g., `Sources/Core/Navigation/`, `Sources/UI/Components/`). As the project scales, deep nesting makes file discovery harder and complicates import/namespace boundaries mentally. 

Alternatives Considered

• Maintain deep nesting (Core vs UI vs Services)
• Feature-based module organization (e.g., Dashboard, Profile)

Decision

Reorganized the folder structure to group files at the top level of `Sources` by their primary role rather than abstract layers:
• `App/`: App entry and high-level routing/state.
• `DesignSystem/`: Theme, colors, typography, spacing.
• `Components/`: Reusable UI elements (Buttons, Cards, States).
• `Utilities/`: Cross-cutting concerns (Logging, Errors).
• `PreviewSupport/`: Mocks and preview containers.
Also added `Assets.xcassets` and `Localizable.strings` at the top level to prepare for localization and standard Apple asset management.

Consequences

Positive
• Flatter structure is easier to navigate.
• Clearer separation of Design System vs Components.
• Better alignment with standard iOS app project structure.

Tradeoffs
• Feature-based modules will need to be introduced carefully later so the top-level doesn't become overly cluttered.

⸻

ADR-007

Date

2026-06-26

Status

Accepted

Decision

Establish a baseline semantic color palette using dynamic code extensions (instead of `.xcassets`) and avoid third-party snapshot testing frameworks (e.g., `swift-snapshot-testing`), relying instead on SwiftUI Previews and XCTest.

Context

We needed comprehensive light/dark mode support and robust UI testing for the design system. However, heavy reliance on `.xcassets` catalogs often causes merge conflicts in large teams. Additionally, while snapshot testing frameworks are valuable for catching pixel-by-pixel regressions, introducing third-party dependencies violates our `AGENTS.md` engineering constitution which emphasizes minimizing external dependencies.

Alternatives Considered

• Store all colors in `Assets.xcassets`.
• Use `swift-snapshot-testing` for visual regression tests.

Decision

1. **Tokens**: Colors are defined in `ColorSystem.swift` using `UIColor` trait collection closures or hex initialization. We established the following baseline Apple-native, premium semantic palette:
   - **Surface**: Dark mode `#0D0D0D` (deep charcoal), Light mode `#F7F7F7` (very light gray).
   - **Accent**: `#007AFF` (Apple's vibrant blue).
   - **Success**: `#34C759` (rich green).
   - **Warning**: `#FFD60A` (warm yellow).
   - **Error**: `#FF3B30` (Apple red).
   - **Neutral**: `#8E8E93` (medium gray).
2. **Testing**: We will rely on rigorous SwiftUI Previews with multiple traits (Dark Mode, Dynamic Type sizes) embedded directly alongside the components and XCTest for logic validation. We will re-evaluate automated visual snapshot testing in later phases once the design stabilizes.

Consequences

Positive
• Zero external dependencies, fully adhering to `AGENTS.md`.
• Highly readable code changes in PRs compared to JSON asset files.
• Clear, semantic mapping for UI state.

Tradeoffs
• We lose the visual color preview afforded by `.xcassets` in Xcode's interface.
• Visual regressions must be caught manually via Previews rather than automated image comparison.

⸻

ADR-008

Date

2026-06-26

Status

Accepted

Decision

Adopt a multi-Router architecture utilizing `NavigationStack` (with `NavigationSplitView` fallback on larger screens) for each main tab, managed by a central `AppCoordinator`.

Context

Pilot requires a navigation system that scales well as new features are added, supports programmatic deep-linking, and handles complex hierarchies (tabs, stacks, and modals). A single global navigation path is insufficient for a multi-tab application where users expect state preservation within each tab.

Alternatives Considered

• A single monolithic global Router.
• Standard `@State` variables directly inside views without coordinators.
• Third-party routing frameworks (e.g., TCA Navigation, XCoordinator).

Decision

1. **Central AppCoordinator**: Manages the currently selected `AppTab` and interprets incoming deep links.
2. **Feature Routers**: Each tab (Home, Money, Wealth, Trust, AI, Automations) instantiates its own generic `Router<Route>`. This router holds a type-safe `NavigationPath` bound to a specific route enum.
3. **Modals**: Global sheets are handled via an optional `GlobalSheetRoute` on the router, providing a clean `.sheet(item:)` presentation pattern.
4. **Adaptive Layout**: Root views adapt automatically based on `horizontalSizeClass`, rendering a `NavigationSplitView` on iPad/Mac and `NavigationStack` on iPhone.

Consequences

Positive
• Strong type safety ensures invalid route transitions do not compile.
• Clear separation of concerns (Views don't manage `NavigationPath`).
• Excellent testability.
• Native Apple APIs with zero external dependencies.

Tradeoffs
• Adds slight boilerplate when establishing a new major tab or route enum.

⸻

ADR-009

Date

2026-06-26

Status

Accepted

Decision

Construct the Home Dashboard using an adaptive `LazyVStack` (iPhone) / `LazyVGrid` (iPad) strategy, orchestrated by a discrete `HomeDashboardViewModel` communicating with an injected `HomeService`. Utilize native SwiftUI Previews over 3rd-party snapshot frameworks.

Context

Phase 04 requires aggregating multiple financial data streams (bills, money, trust score) into a single cohesive "Command Center". The dashboard must remain highly performant, testable, and adaptive to multiple Apple device form factors. Furthermore, we must strictly adhere to the `AGENTS.md` directive of avoiding unnecessary dependencies.

Alternatives Considered

• A single monolithic view with no sub-components.
• Fetching data directly within the `.task` modifiers of individual sub-views.
• `swift-snapshot-testing` for verifying widget layouts.

Decision

1. **Architecture**: We implemented a strict MVVM pattern. The `HomeDashboardViewModel` holds all state and exposes a unified `refresh()` method that fires parallel tasks (`async let`). The View is purely responsible for rendering.
2. **Adaptive Layout**: We use `@Environment(\.horizontalSizeClass)` to determine whether to render widgets in a single-column `LazyVStack` or a multi-column `LazyVGrid`.
3. **Testing & Snapshots**: Conforming to ADR-007 and `AGENTS.md`, we rejected third-party snapshot frameworks. Visual layouts are verified directly through comprehensive SwiftUI Previews within Xcode, testing multiple Dynamic Type sizes and Dark Mode variants natively.

Consequences

Positive
• The unified `refresh()` method makes pull-to-refresh implementation trivial and cohesive.
• View rendering is decoupled from data generation, allowing easy substitution of `HomeMockService` with a real network service later.
• Adaptive layout scales beautifully from iPhone mini to Mac.

Tradeoffs
• Managing multiple optional `@Published` properties in the ViewModel can become verbose.

⸻

ADR-010

Date

2026-06-26

Status

Accepted

Decision

Build a bespoke Conversational UI (AI Copilot) directly using SwiftUI `ScrollViewReader` and custom layout primitives rather than adopting third-party Chat SDKs. Maintain conversational state purely in-memory for this UI-focused phase.

Context

Pilot requires a highly customized AI assistant experience integrating actionable financial cards (`CopilotCard`), context suggestions (`CopilotSuggestion`), and strict adherence to our newly established Design System. Third-party UI SDKs for chat interfaces often force a generic look-and-feel and introduce heavy dependencies that violate `AGENTS.md`. 

Alternatives Considered

• Import a third-party framework like `MessageKit` or a SwiftUI chat library.
• Store messages immediately in `SwiftData` or `UserDefaults`.

Decision

1. **Custom Chat UI**: We built `CopilotView` entirely from scratch using native SwiftUI constructs (`ScrollViewReader`, `LazyVStack`). This allows us to interleave complex financial interactive cards natively within the chat stream.
2. **In-Memory State**: `ConversationViewModel` stores the message array solely in memory during this phase to isolate UI validation from data persistence concerns. Persistence architectures (e.g. `SwiftData`) will be introduced in a future phase.
3. **Structured Cards**: AI responses utilize a `CopilotCard` enum rather than raw text parsing, ensuring a robust, type-safe "Financial Jarvis" experience.

Consequences

Positive
• Absolute control over the aesthetic and interactive feel of the assistant.
• Native integration with Pilot's Theme and Components (haptics, spacing, dynamic type).
• Zero external dependencies.

Tradeoffs
• Managing automatic scrolling (via `ScrollViewReader` and `.onChange`) requires careful handling of SwiftUI edge cases.
• State is lost when the view is destroyed (until persistence is added).

⸻

ADR-011

Date

2026-06-26

Status

Accepted

Decision

In the Money module, accounts will be grouped by `AccountType` in the `MoneyOverviewViewModel` rather than presenting a flat list. Currency formatting and sorting logic will reside entirely within the ViewModels or extensions, keeping the Views strictly declarative.

Context

Phase 06 introduces core banking structures. Users often have multiple accounts (e.g., a primary checking, a joint checking, a savings, and two credit cards). Presenting a flat list makes it difficult to quickly scan for liquidity versus debt.

Alternatives Considered

• Flat list sorted purely by balance.
• Forcing the `MoneyService` to return a nested dictionary.

Decision

1. **ViewModel Grouping**: The `MoneyMockService` returns a flat `[Account]` array, keeping the data layer simple. The `MoneyOverviewViewModel` groups this array by `AccountType` (`.checking`, `.savings`, `.creditCard`).
2. **Explicit UI Ordering**: `MoneyOverviewView` loops over a predefined array of `AccountType` to ensure Checking is always rendered at the top, followed by Savings, then Credit Cards.
3. **Transaction Grouping**: Similarly, `AccountViewModel` handles searching and grouping `[Transaction]` arrays by day, isolating complex `Calendar` logic from the UI.

Consequences

Positive
• The UI hierarchy is highly predictable for the user.
• Views remain incredibly thin, only observing structured data.

Tradeoffs
• ViewModels take on slightly more compute load when parsing and grouping large arrays. (Mitigated by Swift's highly optimized `Dictionary(grouping:by:)`).

⸻

ADR-012

Date

2026-06-26

Status

Accepted

Decision

For the Phase 07 mocked Trust Score, calculate the overall aggregate score deterministically on the client via a weighted average of `TrustMetric` objects inside the `TrustOverviewViewModel`. Additionally, utilize native Swift `Charts` for historical rendering.

Context

The Trust score replaces standard FICO scores. We need a way to display a realistic-looking final score derived from constituent metrics (Income Stability, Savings Habits) without a real backend. Furthermore, we need to chart this history smoothly.

Alternatives Considered

• Fetch a hardcoded overall score directly from `TrustMockService`.
• Draw custom line shapes for the history chart using `Path`.

Decision

1. **Client-Side Weighted Average**: The `TrustOverviewViewModel` calculates the score. By exposing the individual metric weights (e.g., `0.4`), we can write deterministic unit tests verifying the exact score output. *Note: In production (Phase 09+), this calculation will be moved to the backend to protect proprietary scoring algorithms.*
2. **Swift Charts**: We adopt the native `Charts` framework to render the `TrustDetailView` history. This provides automatic accessibility (VoiceOver reads chart data points naturally) and perfectly aligns with the `AGENTS.md` constraint of using native Apple APIs over third-party drawing libraries.

Consequences

Positive
• The architecture is easily testable.
• Swift Charts provides beautiful, animated, and accessible historical views with minimal code.

Tradeoffs
• The client-side calculation logic will eventually need to be deprecated/migrated to the backend.

⸻

ADR-013

Date

2026-06-26

Status

Accepted

Decision

In Phase 08 (Automations), we will use an in-memory storage service (`InMemoryAutomationsStorageService`) rather than `SwiftData`. Furthermore, natural language generation will be built into the `Automation` model itself by iterating over the component Enums.

Context

We need to build a rule engine UI capable of CRUD operations, but the underlying data schema (Triggers, Conditions, Actions) is highly volatile during rapid prototyping. Attempting to lock this into `SwiftData` immediately would introduce unnecessary schema migration headaches.

Alternatives Considered

• Immediate adoption of `SwiftData` with `@Model`.
• Serializing to `UserDefaults`.

Decision

1. **In-Memory Storage**: By abstracting behind the `AutomationsStorageService` protocol, we can use an array-backed store for Phase 08. This allows us to prove the UI flow. We will migrate the concrete implementation to SwiftData/CloudKit in a future phase.
2. **String Generation via Computed Property**: The `Automation.generatedSummary` property iterates over the arrays of Enums and constructs a human-readable sentence. While rudimentary, it is fast and deterministic, eliminating the need for a complex NLP layer right now.

Consequences

Positive
• Maximum flexibility while defining the Trigger/Condition/Action schema.
• Natural language summaries are instantly available and easy to unit test.

Tradeoffs
• Automations will not persist across app restarts until the storage layer is upgraded.⸻

ADR-005

Date

2026-06-26

Status

Accepted

Decision

Adopt a custom, lightweight Dependency Injection container instead of third-party frameworks.

Context

We needed a way to manage services (Mock vs Live) for SwiftUI previews and testing without relying on heavy external dependencies.

Alternatives Considered

• Factory or Swinject (third-party frameworks)
• Passing dependencies through standard initializers only
• SwiftUI Environment Objects exclusively

Decision

Implemented a lightweight `DependencyContainer` initialized with specific services (Configuration, Logger, etc.). It exposes a `.shared` and `.mock` static instance for ease of use in the app lifecycle and SwiftUI Previews.

Consequences

Positive
• Highly readable and simple
• No external dependencies
• Excellent testability

Tradeoffs
• Requires manual wire-up of new services in the container.
