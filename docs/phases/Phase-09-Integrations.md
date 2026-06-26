* AggregationAccount: A model representing a connected account (bank, credit card, investment, etc.).  It should include properties for ID, provider, account type, name, balance, and any other fields used by the Money module.
* Provider: A model representing an external integration provider (e.g. “Mock Bank”, “Plaid”, “Yodlee”).  Include metadata such as name, logo asset, and connection status.
* AggregationError: An enum capturing errors during integration (e.g. authenticationFailed, providerUnavailable, dataFetchFailed).
* AggregationService: A protocol defining methods such as:
    * listAvailableProviders() -> [Provider]
    * authenticate(provider: Provider) async throws -> Void
    * fetchAccounts() async throws -> [AggregationAccount]
    * fetchTransactions(for account: AggregationAccount) async throws -> [Transaction]
    * refreshAccount(_ account: AggregationAccount) async throws -> AggregationAccount
    * unlinkAccount(_ account: AggregationAccount) async throws -> Void
    This defines the contract for any third‑party aggregator.
* MockAggregationService: Implements AggregationService with local JSON.  Provide at least two mock providers (e.g. “Mock Bank” and “Mock Investing”).  When authenticate is called, simply wait asynchronously and then set a local flag.  When fetchAccounts is called, return the content of accounts.json as AggregationAccount models.  When fetchTransactions is called, return transactions.json.
* IntegrationManager: Handles linking/unlinking accounts and maintaining state.  It should hold a reference to the currently selected AggregationService (initially the mock) and coordinate storing linked accounts in persistent storage (via SwiftData).  It should publish changes using Observation so that the Money module updates automatically.

View Models and Views

* IntegrationListViewModel: Provides a list of linked accounts, actions to refresh or unlink, and exposes UI states (loading, error, empty).  It uses the IntegrationManager as a dependency.
* ProviderSelectionViewModel: Presents available providers and handles selection.  It calls authenticate on the service.
* AccountLinkingViewModel: Manages linking selected accounts returned by the service.  It calls fetchAccounts and allows the user to choose which accounts to link.

Views should follow SwiftUI patterns established in earlier phases: reusable cards, spinners, skeleton states, error states, dark/light mode support, and accessible controls.  Use existing design tokens from the Design System (Phase 02) and navigation patterns from Phase 03.  The Connect flow should be intuitive: select provider → authenticate → select accounts → confirm.  Use modals or sheet presentations where appropriate.

Persistence

Use SwiftData to persist linked accounts.  Consider adding a LinkedAccount entity separate from AggregationAccount to avoid persisting external provider data directly.  Linked accounts should have a reference to the provider and store minimal data needed for display (like account name and type).  The IntegrationManager should keep these persistent entities in sync when refreshing or unlinking accounts.

Testing

* Unit Tests: Write tests for the AggregationService protocol.  Verify that the MockAggregationService returns the expected providers, accounts and transactions.  Test that the IntegrationManager correctly links and unlinks accounts, handles errors, and persists data.
* UI Tests: Simulate the user flow of connecting an account, refreshing, and unlinking.  Ensure error states are shown when the mock service throws errors.

Documentation

Create docs/architecture/Integrations.md to describe:

* The purpose and scope of the Integrations module.
* How to implement a new provider by conforming to AggregationService.
* How the IntegrationManager interacts with the Money module and persistence layer.
* Security considerations, such as using tokenized credentials and not storing sensitive data.

Add an entry in DECISIONS.md explaining the choice of a protocol‑based integration layer and why external services are abstracted behind it.

⸻

Build

Work through these steps incrementally:

1. Define models (AggregationAccount, Provider, AggregationError).  Use codable structures to support JSON decoding for the mock.
2. Create the AggregationService protocol with asynchronous methods for listing providers, authenticating, fetching accounts, fetching transactions, refreshing, and unlinking.
3. Implement MockAggregationService using local JSON files.  Place accounts.json and transactions.json in Resources/MockData/.  Provide at least two providers.  Use artificial delays to simulate network latency.
4. Develop IntegrationManager:
    * Inject an AggregationService (defaulting to MockAggregationService).
    * Expose published properties for linked accounts.
    * Provide methods for linking, unlinking, and refreshing accounts that wrap the service calls and handle persistence.
5. Implement view models for provider selection, account linking, and the list of linked accounts.
6. Build the UI:
    * Create an Integrations List screen showing linked accounts and an option to add a new account.
    * Create a Provider Selection screen listing available providers (with name and logo).  When tapped, call authenticate.
    * Create an Account Linking screen showing accounts returned from the service with toggles to select which to link.  Provide primary and secondary actions (e.g. Link, Cancel).
    * Use existing card and list components from the Design System.
    * Support loading and error states with skeletons and alerts.
7. Integrate with Money Module: Modify the Money module to observe changes from the IntegrationManager.  When linked accounts update, merge them into the existing accounts list and reload the Money dashboard.  Use dependency injection to pass the IntegrationManager into Money components.
8. Error Handling: Represent errors from the service in the UI.  For example, if authentication fails, show an alert.  If data fetch fails, allow the user to retry.
9. Persistence & State Restoration: Persist linked accounts.  On app launch, load linked accounts from persistence and rehydrate the IntegrationManager.  Ensure you handle app termination and restart gracefully.
10. Testing: Implement unit tests and UI tests as described.  Use dependency injection to swap in a FailingMockAggregationService to test error cases.
11. Documentation: Write docs/architecture/Integrations.md and update DECISIONS.md with the integration layer design rationale.
12. Review: After building, run the application.  Ensure connecting, refreshing, and unlinking accounts works without crash.  Review accessibility with VoiceOver.  Ensure there are no warnings.  Commit changes with a summary of what was done.

⸻

Design Requirements

* Clarity and Simplicity: The user should always understand what step they’re in.  Each screen should have a single primary action.
* Security Awareness: Explain to the user why linking accounts is safe.  Even though it is a mock, design the UI as if it were real, emphasising encryption and secure connections.
* Consistency: Use the design tokens and components from Phase 02.  Do not introduce new colors or typography.
* Accessibility: All controls must be reachable with VoiceOver.  Provide clear labels for providers and accounts.  Announce loading states and errors.
* Error Feedback: Provide user‑friendly error messages rather than technical codes.
* Graceful Degradation: If no providers are available (e.g. due to lack of network), display an empty state explaining that account linking is unavailable.

⸻

Performance

* Avoid heavy processing on the main thread when decoding mock JSON.  Use background threads and update the UI via the main actor.
* Debounce refresh requests to prevent spamming the service.
* Use caching within the IntegrationManager to avoid unnecessary repeated decoding or network calls.

⸻

Accessibility

* Support Dynamic Type by allowing text to scale across all screens.
* Ensure high contrast and adequate hit targets for interactive elements.
* Describe icons and logos with accessibility labels.
* Provide fallback UI for Reduced Motion (disable animations in transitions).

⸻

Testing

Testing is vital to ensure this architecture remains robust.  Write tests to confirm:

* MockAggregationService returns the correct providers, accounts, and transactions.
* Authentication flow toggles internal state and raises errors appropriately.
* IntegrationManager persists and refreshes linked accounts correctly.
* View models correctly handle success and error states.
* UI flows display loading and error states and update lists upon success.
* Money module updates its accounts when IntegrationManager publishes changes.

⸻

Documentation

After implementing this phase, create docs/architecture/Integrations.md covering:

* The integration abstraction pattern and why it was chosen.
* How to add new providers by creating a new service conforming to AggregationService.
* Security and privacy considerations for storing and handling account data.

Record an ADR (e.g. ADR-00X) in DECISIONS.md documenting the decision to introduce the AggregationService protocol and IntegrationManager and to stub out integration functionality instead of implementing real networking now.

⸻

Completion

Once all tasks are finished:

1. Verify the app runs without warnings.  Connect a mock account, refresh it, and unlink it.  Confirm Money updates accordingly.
2. Review tests and ensure they pass.  Add coverage as needed.
3. Update documentation and DECISIONS.md with the decisions and rationale.
4. Do not begin Phase 10.  Instead, summarise the completed integration architecture, note any shortcomings or open questions, and wait for approval before proceeding.
