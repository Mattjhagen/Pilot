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
• Visual regressions must be caught manually via Previews rather than automated image comparison.⸻

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
