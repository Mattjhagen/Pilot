# Pilot Integrations Architecture

## Philosophy

The Integrations layer forms the bridge between Pilot and external financial institutions. To maintain absolute flexibility and security, all external communication is abstracted behind a strict protocol (`AggregationService`). This allows us to swap underlying vendors (e.g., Plaid, Yodlee, MX) without altering the frontend or internal data models.

## Components

### Data Models
Located in `IntegrationModels.swift`.
- `Provider`: The external institution (e.g., Chase, Robinhood).
- `AggregationAccount`: The raw data structure returned by the provider.
- `LinkedAccount`: The persistent representation of a user's choice to link a specific account. This model intentionally stores minimal data (no raw balances or PII) to optimize security. 
- `AggregationError`: Standardized error mapping.

### Service Layer
- `AggregationService`: The core protocol handling authentication, fetching, and unlinking.
- `MockAggregationService`: A client-side stub returning synthetic data with simulated network delays and occasional random authentication failures.

### Managers
- `IntegrationManager`: A global `@Observable` singleton-like manager. It orchestrates the connection flows and maintains the array of `linkedAccounts`. The Money tab observes this manager directly to dynamically combine linked accounts with existing accounts.

### Interface
- `IntegrationsOverviewView`: Displays linked accounts and allows unlinking.
- `ProviderSelectionView`: Renders the list of supported institutions.
- `AccountLinkingView`: After authentication, presents the sub-accounts available for import.

## Note on External Networking
In this phase, absolutely no real network requests are made. The `MockAggregationService` simulates the entire OAuth and data-fetching pipeline.
