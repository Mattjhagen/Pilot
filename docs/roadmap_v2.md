# Pilot Roadmap V2: The Backend Transition

With V1 (the interactive mock prototype) complete, V2 focuses on replacing the mock services with real backend infrastructure, APIs, and persistence layers.

## Phase 11: Core Persistence (SwiftData/CloudKit)
- **Goal**: Replace in-memory storage for Automations, Integrations, and active Loans with a robust SwiftData schema.
- **Tasks**:
  - Define `@Model` classes.
  - Implement schema migrations.
  - Enable CloudKit sync so user data persists across devices.

## Phase 12: Real Integrations (Plaid / Yodlee)
- **Goal**: Swap `MockAggregationService` for a real third-party SDK to fetch live bank data.
- **Tasks**:
  - Implement `PlaidAggregationService` conforming to `AggregationService`.
  - Securely manage OAuth tokens in the iOS Keychain.
  - Transition the Money module to consume live balances.

## Phase 13: Live AI Copilot (LLM Integration)
- **Goal**: Connect the AI tab to a real Large Language Model (e.g., Gemini or OpenAI).
- **Tasks**:
  - Implement RAG (Retrieval-Augmented Generation) so the LLM can securely query the user's live financial data.
  - Stream responses to the UI using AsyncThrowingStreams.

## Phase 14: Automated Money Movement (ACH / Webhooks)
- **Goal**: Allow the Automations engine to actually move money.
- **Tasks**:
  - Integrate a Banking-as-a-Service (BaaS) provider.
  - Implement webhook listeners on the backend to trigger rules when paychecks arrive.
  - Handle real transaction states (pending, settled, failed).

## Phase 15: Underwriting & KYC
- **Goal**: Turn the mock Lending engine into a compliant origination platform.
- **Tasks**:
  - Integrate real KYC (Know Your Customer) APIs (e.g., Persona or Stripe Identity).
  - Transition the Trust Score algorithm from the client side to a secure backend engine.
