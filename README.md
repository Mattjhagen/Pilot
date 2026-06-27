# Pilot - AI Financial Operating System

Pilot is a modern, modular, AI-powered financial operating system designed for iOS. It eschews traditional budgeting in favor of an intelligent, proactive architecture that feels like a dedicated CFO in your pocket.

## Overview

This repository contains the **v1.0 Mock Prototype** of Pilot. It implements a complete UI/UX and architectural foundation using Swift, SwiftUI, and Observation. To allow rapid iteration, external APIs (banking, lending, KYC) have been securely mocked behind protocol boundaries.

## Features

- **Dashboard**: A dynamic command center outlining available cash, upcoming bills, and immediate AI insights.
- **AI Copilot**: A conversational interface leveraging a (mock) LLM to analyze spending and recommend actions.
- **Money**: An aggregated view of all linked checking, savings, and credit accounts.
- **Trust**: An alternative credit-scoring engine evaluating spending habits over raw FICO scores.
- **Automations**: A natural-language rule builder for "If This, Then That" financial workflows.
- **Integrations**: A secure, protocol-based mock system for linking external bank accounts.
- **Lending**: A dynamic loan origination flow offering discounts based on the user's Trust Score.

## Architecture

Pilot enforces strict architectural boundaries:
- **Views**: Declarative SwiftUI structures handling state display.
- **ViewModels**: Powered by `@Observable`, orchestrating state and business logic.
- **Services**: Abstracted protocols (`TrustService`, `MoneyService`, `LendingService`) hiding the underlying mock logic (and eventually the real network stack).
- **Navigation**: Managed through strongly-typed enums and a multi-router `AppCoordinator` pattern.

For detailed architectural breakdowns, see:
- [Design System](docs/architecture/DesignSystem.md)
- [Automations](docs/architecture/Automations.md)
- [Integrations](docs/architecture/Integrations.md)
- [Lending](docs/architecture/Lending.md)

## Building the Project

We use `xcodegen` to maintain a clean project structure.

1. Ensure [XcodeGen](https://github.com/yonaskolb/XcodeGen) is installed (`brew install xcodegen`).
2. Run `xcodegen generate` from the root directory.
3. Open `Pilot.xcodeproj`.
4. Select an iOS Simulator and press Run.

## Roadmap & Decisions

All technical decisions are recorded as ADRs in [DECISIONS.md](DECISIONS.md).

For the upcoming phases focusing on real backend synchronization and third-party APIs, see [roadmap_v2.md](docs/roadmap_v2.md).
