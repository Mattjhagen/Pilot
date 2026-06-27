# Pilot Architecture

This document defines the strict, non-negotiable architectural rules for the Pilot repository.

## Core Engine

The `PilotCoreEngine` never performs domain calculations itself. It coordinates specialized engines and publishes unified operating state. It is the conductor, not a "God object".

The engine pipeline maps directly to the cognitive flow:
`PilotCoreEngine` -> `ObservationEngine` -> `InterpretationEngine` -> `MemoryEngine` -> `ReasoningEngine` -> `RecommendationEngine` -> `AutomationEngine` -> `Presentation`

## Data Flow

Data always flows in one direction, ascending the cognitive pipeline:
External Sources -> Observation -> Interpretation -> Memory -> Reasoning -> Recommendation -> Automation -> Presentation

## Architecture Freeze

The repository structure, top-level pillars, dependency rules, and engine responsibilities are considered officially frozen. 

- No new top-level pillars.
- No engine renames.
- No folder restructuring.
- No new architecture phases.
- Exceptions only if real implementation proves a limitation.

Future work should prioritize new capabilities rather than structural refactoring.

## 1. Top-Level Pillars

- **`Core/`**: The operating system layer. Bootstraps the app, injects dependencies, handles navigation, feature flags, and global configuration.
- **`DesignSystem/`**: Pure UI building blocks. Theme tokens, Charts, Reusable Components. Knows absolutely nothing about business logic.
- **`Models/`**: Pure, domain-based data structures (e.g. `Accounts/`, `Trust/`). Models must not contain networking logic or SwiftUI imports.
- **`Engines/`**: Deterministic background calculators (Financial Health, Trust, etc.).
- **`Experiences/`**: The actual features (Command Center, Money, Trust, Lending). Experiences bind State to DesignSystem components.
- **`Platform/`**: External communication (Networking, Persistence, Authentication, Analytics, API integration).
- **`Shared/`**: Global utilities, extensions, constants, and protocols.
- **`PreviewData/`**: Rich mock datasets (e.g. `HealthyUser`, `PaycheckToPaycheck`) to power realistic SwiftUI Previews.
- **`Developer/`**: Internal tools, galleries, and inspectors used only in `#if DEBUG` or developer builds.

## 2. Dependency Rules

Upward dependencies are strictly forbidden to prevent architectural drift.

- **`DesignSystem`**: Imports NOTHING (except SwiftUI).
- **`Models`**: Imports NOTHING (except Foundation).
- **`Engines`**: Imports `Models`. Never imports `DesignSystem` or performs Networking.
- **`Platform`**: Imports `Models`. Performs networking/persistence.
- **`PreviewData`**: Imports `Models`.
- **`Experiences`**: Imports `DesignSystem`, `Models`, `Engines`, `Platform`.
- **`Developer`**: Can import everything.

## 3. Engine Rules
An Engine must:
✅ Accept Models.
✅ Return Models.
✅ Never know about SwiftUI.
✅ Never import DesignSystem.
✅ Never perform raw networking.

## 4. UI Rules & Linting
Design enforcement should be handled gradually via Linting rules rather than blanket regex replacements.
- ❌ Hardcoded Apple system colors (`Color.blue`, `Color.gray`, `Color.white`). Use `ColorTokens`.
- ❌ Hardcoded exact padding (`.padding(16)`). Use `Spacing` tokens where appropriate.
- ❌ Ad-hoc animation (`.animation(.easeInOut)`). Use `MotionEngine`.
Semantic fonts (`.title`, `.headline`) are permissible where dynamic typing relies on Apple's standard contextual hierarchy, but custom typography should prioritize `TypographyTokens`.
