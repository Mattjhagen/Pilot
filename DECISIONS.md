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

Manage Design System semantic colors and theme tokens via dynamic code extensions rather than `.xcassets` catalogs, and avoid third-party snapshot testing libraries.

Context

We need comprehensive light/dark mode support and robust snapshot testing for the design system. However, heavy reliance on `.xcassets` catalogs often causes merge conflicts in large teams, and third-party snapshot testing libraries violate our goal of avoiding external dependencies unless strictly necessary.

Alternatives Considered

• Store all colors in `Assets.xcassets`.
• Use `swift-snapshot-testing` for visual regression tests.
• Use SwiftUI Environment objects exclusively for theming.

Decision

1. **Tokens**: Colors are defined in `ColorSystem.swift` using `UIColor` trait collection closures. This gives us full programmatic control over dynamic light/dark mode resolution while keeping git history readable.
2. **Testing**: Instead of third-party snapshot libraries, we will rely on rigorous SwiftUI Previews with multiple traits (Dark Mode, Dynamic Type sizes) embedded directly alongside the components.
3. **Typography/Spacing**: Managed via static extensions on `Font` and custom `Spacing` structs to maintain a completely native, lightweight footprint.

Consequences

Positive
• Zero external dependencies.
• Highly readable code changes in PRs compared to JSON asset files.
• Faster build times.

Tradeoffs
• We lose the visual color preview afforded by `.xcassets` in Xcode's interface.
• Visual regressions must be caught manually via Previews rather than automated image comparison (until Apple provides a native snapshot tool).⸻

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
