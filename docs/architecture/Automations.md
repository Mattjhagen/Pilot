# Pilot Automations Architecture

## Philosophy

The Automations tab allows users to build "If This, Then That" rules for their finances. The system must be incredibly transparent so users explicitly understand when and how their money moves.
- **Natural Language Parsing**: Rules are parsed into readable English strings (e.g., "When paycheck is received, transfer 10% to Savings").
- **Modular Components**: `Trigger`, `Condition`, and `Action` enums.
- **Simulations**: Test-runs provide mocked validation to reduce anxiety before enabling a new automation.

## Components

### Data Models
Located in `AutomationModels.swift`.
- `Automation`: Top-level struct containing its rule definition and an `isEnabled` boolean.
- `Trigger`: How the rule starts (`.paycheckReceived`).
- `Condition`: Filters for the trigger (`.balanceGreaterThan`).
- `Action`: The resulting execution (`.transferToSavings`).

### Service Layer
Located in `AutomationServices.swift`.
- `AutomationsStorageService`: Handles CRUD ops. Currently backed by `InMemoryAutomationsStorageService` to prioritize rapid UI development and avoid schema locks.
- `AutomationRunner`: A mocked simulator (`AutomationMockRunner`) that evaluates the `Action` types inside an `Automation` and returns a theoretical string output.

### View Models
- `AutomationsOverviewViewModel`: Fetches the list of automations and handles toggling enable/disable states.
- `AutomationBuilderViewModel`: Provides temporary, isolated state for editing. Includes `.isValid` logic ensuring an automation has a name, at least one trigger, and at least one action before allowing a save.

### Interface
- `AutomationsOverviewView`: Displays `AutomationCardView` items with toggle switches.
- `AutomationBuilderView`: Multi-section editing form. Provides sub-sheets for `TriggerPickerView` and `ActionPickerView`.
- `AutomationSimulationView`: Consumes the `AutomationRunner` and provides a summary.

## Note on Execution
In this phase, automations are strictly structural/mocked. No background daemon exists to execute real banking actions based on time or webhooks.
