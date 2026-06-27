# Pilot Dashboard Architecture

## Philosophy

The Home Dashboard serves as the "Command Center" of Pilot, aggregating crucial financial data into modular, bite-sized widgets. It adheres to these core principles:
- **Prioritization**: Critical info (Available Money, Quick Actions) surfaces at the top.
- **Adaptive**: Utilizes `LazyVStack` on iPhones and `LazyVGrid` on larger devices (iPad/Mac).
- **Decoupled**: `HomeDashboardViewModel` acts as the single source of truth, fetching from a dedicated `HomeService`. Views simply observe and render.
- **Previewable**: Heavily relies on mock implementations and SwiftUI Previews for visual snapshot testing.

## Components

### Data Models
Located in `HomeModels.swift`. These are lightweight, Decodable-ready `structs` such as `AvailableMoney`, `UpcomingBill`, and `AIInsight`.

### Service Layer
`HomeService` defines the asynchronous data-fetching protocol. `HomeMockService` provides localized, sleep-delayed mock generation for testing and UI layout. This is injected into the ViewModel via the `DependencyContainer`.

### View Model
`HomeDashboardViewModel` handles state orchestration.
- Exposes optional `@Published` data.
- Provides `refresh()` which fires parallel asynchronous tasks (`async let`) to quickly update all widgets simultaneously.

### Widgets
Modular UI pieces located in `HomeWidgets.swift`. 
Examples: `AvailableMoneyCard`, `QuickActionsRow`, `TrustScoreCard`. Each card accepts its specific model and wraps it in a `PilotCard`.

## Future Live Activity Integration (Phase 09)

A `LiveActivityPlaceholder` has been reserved at the top of the ScrollView. In Phase 09, this will be replaced with a live ActivityKit component to track active rides, food deliveries, or ongoing financial transfers in real-time.
