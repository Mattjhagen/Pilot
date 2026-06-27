# Pilot Money Architecture

## Philosophy

The Money tab is designed to be the canonical source of truth for the user's financial accounts. It adheres to these core principles:
- **Calm & Clear**: Whitespace and structural alignment prioritize readability for critical metrics (balances).
- **Hierarchical**: Accounts are grouped by type (Checking, Savings, Credit). Within an account, quick actions and summaries precede the transaction history.
- **Adaptive**: Built on `NavigationSplitView` and `NavigationStack`, automatically accommodating iPhone and iPad sizes.

## Components

### Data Models
Located in `MoneyModels.swift`.
- `Account`: Stores top-level banking data (type, balance, etc.).
- `Transaction`: Represents individual ledger items, bound to an `Account` via `accountId`. Includes a `TransactionCategory` for semantic icon rendering.

### Service Layer
`MoneyService` (currently mocked via `MoneyMockService`) provides realistic banking structures. It injects a delay via `Task.sleep` to simulate external banking API aggregation. This will be swapped out for a true financial API provider (e.g., Plaid integration) in Phase 09.

### View Models
- `MoneyOverviewViewModel`: Responsible for fetching all user accounts and bucketing them by `AccountType`.
- `AccountViewModel`: Responsible for loading transactions for a selected account, applying text-based search filters, and grouping transactions by `Date`.

### Interface
- `MoneyOverviewView`: The root screen grouping accounts via `AccountCardView`.
- `AccountDetailView`: The zoomed-in ledger. Presents quick actions and uses `TransactionRowView` within a `LazyVStack`.
- `TransactionDetailView`: Deep dive on an individual transaction, allowing hypothetical disputes or recategorization.

## Simulated Data Notice
Because Pilot does not yet connect to live institutions, all balances and quick actions (Send, Deposit, Transfer) are simulated and trigger generic placeholder alerts. No real money movement occurs in this phase.
