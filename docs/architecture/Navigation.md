# Pilot Navigation Architecture

## Philosophy

The navigation in Pilot is designed to be:
- **Type-Safe**: All routes are explicitly defined as `enums`.
- **Modular**: Each major tab has its own independent `Router` holding its `NavigationPath`.
- **Adaptive**: Utilizes `NavigationSplitView` on iPad and Mac, falling back to `NavigationStack` on iPhone based on horizontal size classes.
- **Deep-Link Ready**: The central `AppCoordinator` can easily parse incoming URLs and direct them to the appropriate `Router`.

## Components

### `AppCoordinator`
The global state object living at the root of the app. It holds:
- The currently selected `AppTab`.
- A dedicated `Router` for each feature tab (e.g., `homeRouter`, `moneyRouter`).
- A `handleDeepLink(_:)` function to parse URL schemes.

### `Router<Route>`
A generic, `@Observable` class that wraps a `NavigationPath` and an optional `GlobalSheetRoute` for modals.
Methods:
- `push(_ route: Route)`
- `pop()`
- `popToRoot()`
- `presentSheet(_ sheet: GlobalSheetRoute)`

### Route Enums
Defined in `RouteEnums.swift`. Every tab has a specific enum (e.g., `MoneyRoute` with cases like `.transactionDetail(id: UUID)`).

## Adding a New Route

1. Open `RouteEnums.swift` and add a new case to the relevant tab's route enum.
2. Open the root view for that tab (e.g., `MoneyView.swift`).
3. Add a new `case` in the `.navigationDestination(for:)` switch statement and return the corresponding destination view.
4. From anywhere inside that tab, call `router.push(.yourNewRoute)`.
