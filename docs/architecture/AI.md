AI Core Service (AIService)

The AIService defines the contract for interacting with AI models. It is a protocol that exposes methods such as:

* generateResponse(for input: AIInput, context: AIContext) async throws -> AIOutput
* generateInsight(for context: AIContext) async throws -> AIInsight
* summarizeData(_ data: SomeData) async throws -> AISummary
* createAutomationSuggestion(for context: AIContext) async throws -> AutomationSuggestion

AIService should be implemented by:

* RemoteAIService – wraps calls to external AI providers (e.g. OpenAI, Anthropic, Apple). It handles API keys, rate limiting, and error handling. Data is anonymized or aggregated before sending when possible.
* LocalAIService – uses on-device models where supported (e.g. Apple Intelligence) to keep sensitive data local. This may be limited in capabilities but provides privacy-first operations.
* MockAIService – for development and testing. It returns canned responses and can simulate service errors.

AI Context Manager (AIContextManager)

AIContextManager aggregates data from Data Providers and the Memory Store to produce a coherent context object for each AI call. It can:

* Combine user’s financial snapshot (balances, transactions, upcoming bills, subscriptions, goals, trust score) into a structured context object.
* Merge conversation history, previous AI responses, and user preferences.
* Provide hashed or anonymized identifiers to external AI services if needed.
* Provide conversation metadata (e.g. language preference, time zone, locale) to adapt responses.

It exposes methods such as:

* currentContext() -> AIContext
* updateContext(with newEvent: AIEvent) -> Void

Data Providers (AIDatapointProvider)

Data Providers are protocols implemented by each module (Money, Trust, Lending, Integrations, Automations) to supply the AI with relevant data in a structured way. Each provider defines methods such as:

* getRecentTransactions() -> [Transaction]
* getTrustMetrics() -> TrustMetrics
* getUpcomingBills() -> [Bill]
* getActiveLoans() -> [LoanAgreement]

These protocols ensure the AI accesses data in a consistent, decoupled way and avoid tight coupling between the AI and the rest of the system.

AI Action Engine (AIActionEngine)

The AIActionEngine interprets AI output (recommendations, insights, suggested automations) and maps them into actionable operations. For example:

* Turning a recommendation into an automation rule. If the AI suggests “Invest $100 on Friday”, the Action Engine can generate a new automation, ask for user confirmation, and add it to the Automations module.
* Triggering a payment. If the AI warns that a bill is overdue, the Action Engine can pre-fill a payment flow in the Money module.
* Creating a goal. If the AI suggests saving for a specific purpose, the Action Engine can create a goal in the Goals module and pre-allocate funds based on user consent.

The Action Engine must always request user confirmation before executing actions that modify financial data.

Local Memory Store (AIMemoryStore)

The Memory Store persists conversation history, user preferences, and contextual information on device. It stores:

* Recent AI interactions (message content, timestamps, relevant context pointers).
* User-specific insights and whether the user accepted, rejected, or ignored them.
* User preferences such as notification settings, privacy level, and language.

Implementation should use an encrypted persistent storage mechanism (e.g. SwiftData with encryption) and ensure data is wiped when the user logs out. No sensitive information leaves the device without explicit consent.

User Preference Manager (AIUserPreferenceManager)

This component manages user-facing settings for the AI system. These settings may include:

* Insight frequency: How often the AI surfaces proactive insights (e.g. daily, weekly, monthly, or custom).
* Notification channels: In-app, push notifications, email, Live Activities, or none.
* Privacy level: Whether the AI can send anonymized data to remote services, or must operate solely on local data.
* Language and tone preferences.
* Opt-in/out for specific types of recommendations (e.g. investment suggestions, subscription management).

User preferences should be accessible from the app settings and persisted across sessions.

Notification & Alert Manager (AINotificationManager)

This component is responsible for delivering the AI’s proactive notifications and alerts. It uses the system’s notification framework, Live Activities, and widgets. It ensures:

* Notifications respect user preferences (as managed by AIUserPreferenceManager).
* Alerts are scheduled at appropriate times (e.g. not in the middle of the night unless urgent).
* The content of notifications is concise, actionable, and clearly states whether the user needs to take action or if the AI has already done something.
* Tapping a notification navigates the user to the relevant view in the app (e.g. bill payment screen, automation review screen).

Data Flow

1. Event Trigger: A new data event occurs (e.g. new transaction, updated Trust Score, upcoming subscription renewal) or user initiates a conversation with the AI.
2. Context Build: AIContextManager collects necessary data from AIDatapointProviders, plus conversation history from the Memory Store.
3. AI Processing: The AIService is called with the input and context. It chooses the appropriate model (remote or local) and returns an AIOutput object which may contain:
    * A conversation reply (text plus optional attachments or cards).
    * One or more AIInsights (proactive advice or warnings).
    * Suggested Automations or actions.
4. Action Handling: The AIActionEngine interprets the insights and suggestions. It either produces automation rules, payment flows, or other actionable items. It informs the relevant module (e.g. Money or Automations) once the user confirms.
5. Notification: If the output is proactive, the AINotificationManager prepares and schedules notifications according to user preferences.
6. Memory Update: The AIMemoryStore records the input, context, AI output, user responses, and outcomes. This ensures context continuity and personalizes future interactions.

Privacy & Security

* Data Minimization: Only include necessary data in AI context. Sensitive fields (e.g. account numbers) must be hashed or omitted entirely.
* On-Device First: Prefer using LocalAIService to avoid sending data externally. If an external service is used, ensure it is anonymized. Display clear consent dialogues before any data leaves the device.
* Encryption: Store conversation history and AI context in encrypted form. Use the Keychain or Secure Enclave where appropriate for tokens or sensitive states.
* Access Control: Respect system-level privacy settings (e.g. App Tracking Transparency) and provide in-app settings to control AI behavior.

Extending the AI

Adding new AI capabilities requires:

* Defining a new AIOutput type or extending existing ones (e.g. new insight type, new automation type).
* Updating the AIService protocol to include the generation method for that capability.
* Implementing support in MockAIService, and eventually in RemoteAIService and LocalAIService once the integration is ready.
* Extending AIContextManager to gather any additional data required by the new capability.
* Updating the UI to support displaying the new output or suggestions. This may involve creating new card views or form screens.
* Adding tests to verify the new capability behaves as expected.
* Documenting the changes in the architecture documentation and creating an ADR if the new capability introduces significant architectural changes.

Testing Strategy

Testing the AI subsystem requires a combination of unit tests, integration tests, and UI tests:

* Unit Tests: For AIService implementations, ensure correct parsing of AI outputs, correct error handling, and that the service honors privacy settings. For AIContextManager, ensure context objects are correctly built and updated.
* Integration Tests: Test flows that require cooperation between modules (e.g. a loan suggestion triggered by the Trust score and processed by Lending and Money modules). Use MockAIService to simulate the AI response.
* UI Tests: Validate that conversation UI displays AI responses correctly, that proactive notifications open the correct screens, and that user actions (accepting/rejecting recommendations) propagate properly.

Use dependency injection extensively to swap out real AI services with mocks or stubs during tests.

Known Limitations & Future Work

* Model Implementation: The current architecture assumes modular AI service providers, but implementing the actual models is out of scope for this phase. Partnering with external providers or building on-device models will come later.
* Learning & Personalization: The AI does not yet implement reinforcement learning or long-term personalization beyond storing history. Future versions may improve by learning from user behavior with explicit consent.
* Multilingual Support: The AI currently assumes a single language context. Expanding to multilingual support will require context language detection and translation layers.
* Explainability: While basic context explanation is built in, deeper explainability (e.g. showing how a trust score influenced a recommendation) will need further work.
* Regulatory Compliance: Future phases must include compliance checks for AI recommendations and ensure fairness in lending and credit suggestions. The architecture must be extended to incorporate compliance modules.

Conclusion

The AI subsystem is the brain of the Pilot financial operating system. By separating concerns into a flexible AIService, context management, data providers, action engines, and supporting components, the system remains adaptable to new AI providers and capabilities while prioritizing user privacy and control. This architecture ensures that Pilot can evolve into a truly intelligent, proactive assistant for personal finance without sacrificing clarity, transparency, or security.
