• Account: struct with fields like id, name, type (checking, savings, credit), maskedNumber, balance, availableBalance, interestRate (optional), currency.

• Transaction: struct with id, accountId, date, description, amount, category (TransactionCategory), status (pending, posted), and optional metadata (merchant info, notes).

• TransactionCategory: enum or struct with category name (e.g. groceries, transportation, rent) and an SF Symbol for icon representation.

• Budget (optional): struct with category, limit and current spend.

• MoneyMockService: returns arrays of sample accounts and transactions. Provide variety in sample data to exercise lists and filters.

• MoneyOverviewViewModel: responsible for fetching accounts from the mock service and exposing them to the view. Handles navigation events (e.g. selecting an account). Use dependency injection to provide the mock service.

• AccountViewModel: holds the selected account and its transactions. Provides filtering logic based on search text and selected category/date range. Exposes quick action handlers that currently show placeholder views or alerts.

⸻

Build

1. Mock Data and Service: Implement MoneyMockService. Create several sample accounts (checking, savings, credit card). For each account, generate 30–50 sample transactions across various categories with positive and negative amounts. Ensure there are pending transactions and posted transactions for realism.
2. Overview Screen: Build MoneyOverviewView using a vertical scroll or list. For each account, render an AccountCardView. Cards should show masked numbers (e.g. “•••• 1234”), balances with appropriate currency formatting, and available/credit limits. Use color cues: positive balances in primary color, negative in warning/error color. Tapping a card pushes AccountDetailView onto the navigation stack.
3. Account Detail View: Compose sections:
    * Account Summary: Display account type, masked number, interest rate (if savings), last updated time. Use the design system’s CardView with bigger typography for the balance.
    * Quick Actions Row: Use horizontal scroll or grid to display buttons for actions (send money, deposit, transfer, pay bill, etc.). Connect buttons to ActionPlaceholderView that describes the feature and notes that real transfers will be implemented later.
    * Spending Summary (optional): Display a simple bar chart or ring using ProgressView or a custom gauge showing spending vs. a budget or vs. previous period. Only include this if it answers a question; do not add a chart for decoration.
    * Transaction List: Use TransactionListView to display transactions grouped by date. Provide a search bar at the top of the list and a filter bar for categories/date range. Each transaction row uses the design system’s typography and icons.
4. Transaction Detail View: When a transaction is tapped, push TransactionDetailView. Show details: description, merchant (if available), category, date/time, amount, status, notes. Provide placeholder buttons for adding receipts, disputing, or changing the category. These actions should show alerts or placeholder screens.
5. Link Account Flow: Create LinkAccountView that describes linking a new account. Provide a list of fictional institutions or a button labeled “Choose Bank” that opens a placeholder modal. Provide text fields or placeholders for credentials. Use multi-step UI with a progress indicator. For now, always succeed and show a confirmation message that the account was added (but do not modify the account list unless you implement local state persistence).
6. Budgets (Optional): If implementing budgets, build BudgetSummaryView that shows categories and their spending vs. budget. Provide a “Create Budget” button that opens a placeholder. For now, budgets can be statically defined in the mock service.
7. Accessibility and Localization: Ensure currency values use NumberFormatter with locale awareness. Add accessibility descriptions for amounts (“minus twenty‑three dollars and fifty cents”) and for masked account numbers (“account ending in one two three four”). Support dynamic type and high contrast. Label quick action buttons clearly (“Send Money Button”).
8. Animations and Haptics: Use subtle animations when expanding sections or pulling to refresh. Provide light haptic feedback on quick action taps. Do not animate sensitive elements like account balances unnecessarily.
9. Previews and Tests: Provide previews for each component (cards, detail views) in light/dark modes and different dynamic type sizes. Write unit tests for MoneyOverviewViewModel and AccountViewModel verifying data loading and filtering logic. Add snapshot tests for overview and detail screens.

⸻

Design Requirements

• Calm and Clear: The Money module should convey trust and clarity. Use whitespace effectively. Make sure balances and transaction amounts are easy to read. Use icons sparingly and consistently with the design system.

• Hierarchy: On the overview screen, prioritize accounts by importance (e.g. primary checking first). Within account details, show the balance prominently, then recent transactions, then older history.

• Consistency: Reuse card and list patterns from the design system. Quick action buttons should match the style defined in Phase 02. Use consistent color for negative amounts (e.g. red) and positive amounts (e.g. green or primary color).

• Visual Cues: Pending transactions could appear in italic or with a different opacity. Group transactions by date with headers. Use category icons from TransactionCategory definitions.

• Cautions: Because this phase does not implement real transfers or account linking, clearly mark placeholder actions with labels like “Coming Soon” or “Simulated”. Avoid any UI that implies real money movement without the user’s explicit understanding.

⸻

Performance

• Use LazyVStack and LazyHStack for lists of accounts and transactions. Avoid preloading all transactions if there are many (although the mock service may have limited items).

• Avoid expensive state updates when filtering. Debounce search input if implementing live search.

• Format currency values outside the view body to avoid repeated work.

⸻

Accessibility

• Ensure that amounts and dates are spoken correctly by VoiceOver. Use .accessibilityValue(Text(formattedAmount)) rather than the raw string.

• Group related elements together (.accessibilityElement(children: .contain)), such as account summary details.

• Add accessibilityHint to quick action buttons explaining what will happen when real functionality is implemented.

• Support keyboard navigation for lists and actions.

• Respect system settings for text size, bold text, high contrast and reduce motion.

⸻

Testing

• Unit Tests: Test that the mock service returns correct sample data. Test that filtering by category/date in AccountViewModel works as expected.

• Snapshot Tests: Capture the Money overview, account detail, and transaction detail in light and dark modes. Ensure that changes to design system or fonts are intentional.

• UI Tests: Simulate tapping account cards, navigating to details, searching transactions, and triggering placeholders. Verify that no crashes occur and that placeholders show as expected.

⸻

Documentation

Create /docs/architecture/Money.md explaining:

• The data models (Account, Transaction, etc.) and their relationships.

• How the mock service supplies data and how to replace it with a real aggregator in Phase 09.

• The architecture of view models and how they handle filtering and quick actions.

• How placeholder actions are implemented and where real logic will be plugged in later.

Document any important decisions (e.g. how accounts are ordered, choice of quick actions) in DECISIONS.md.

⸻

Completion

When this phase is complete:

• Run the app on different devices and settings to verify the Money module’s appearance and behavior. Ensure that all placeholder actions clearly communicate their simulated nature and that no real financial operations occur.

• Summarize the Money module implementation and note any limitations or things to address in later phases (e.g. persistent storage, real API integration, error handling, multi‑currency support).

• Update DECISIONS.md with major architectural or UX choices made during this phase.

After summarizing and documenting, do not begin Phase 07. Wait for review and approval.

⸻

Do not begin the next phase, even if you believe there is remaining context. Your job is to complete only this phase, verify it builds cleanly, update DECISIONS.md with any architectural decisions, summarize the work performed, and wait for further instructions.
