• ChatMessage: a value type representing a single message. Include id, role (user, assistant, system), content (String), timestamp, and an optional card (enum or associated type) for structured responses.

• CopilotSuggestion: define suggestions with a title, subtitle (optional), and an associated action type. Suggestions can be generated based on the last user message or time of day.

• CopilotCard: an enum representing card types (e.g. insight, recommendation, alert) with associated data (e.g. title, description, button actions).

• ConversationViewModel: an ObservableObject that holds @Published var messages: [ChatMessage] and @Published var suggestions: [CopilotSuggestion]. Provide methods send(_ message: String), selectSuggestion(_ suggestion: CopilotSuggestion), and generateMockResponse(). Use a CopilotMockService to fetch random sample responses and suggestions.

• CopilotMockService: a simple service that returns arrays of sample messages, cards and suggestions. For example, sampleInsights, sampleRecommendations, sampleAlerts, sampleSuggestions. Provide randomness to simulate variety.

• Views: CopilotView composes the chat interface. Use a ScrollViewReader or List for messages; ChatMessageRow renders each message bubble or card; InputBar contains the text field, send button, and voice button; SuggestionsBar displays suggested actions horizontally.

⸻

Build

1. Models and Service: Define ChatMessage, CopilotCard and CopilotSuggestion. Implement CopilotMockService with sample content. Example messages: “You spent 23% less eating out this week”, “Your checking balance will fall below $400 next Thursday”, “You can safely invest another $200 this month”. Example cards: investment recommendation with a “Invest Now” button; subscription alert with a “Cancel” button.
2. ViewModel: Implement ConversationViewModel. Initialize it with an intro message from the assistant (“Hi! I’m your Copilot. How can I help?”). Provide send(_:) that appends a user message and then triggers generateMockResponse() after a short delay. generateMockResponse() picks a random insight or card from CopilotMockService and appends it as an assistant message. Also update suggestions based on the last user message or time of day.
3. Chat Interface: In CopilotView, create a List or ScrollView for messages. Use ChatMessageRow to differentiate between user and assistant messages: user messages align to the right with a distinct background color, assistant messages align to the left with a tinted card background. When a message has an associated card, display the card view with interactive buttons.
4. Input Bar: Build a custom view with a multiline text field (or single line if preferred) and a send button. Disable the send button when the text is empty. Pressing send calls viewModel.send(text), clears the input and scrolls to the bottom.
5. Suggestions Bar: Create a horizontally scrolling bar showing CopilotSuggestion items. Each suggestion displays a short label and optionally an icon. Tapping a suggestion either sets the input field to the suggestion text or directly calls viewModel.selectSuggestion() to generate a response.
6. Voice Input Placeholder: Add a mic icon button in the input bar. When tapped, show a simple alert (“Voice input coming soon”) or print to console. Style the button according to the Design System.
7. Accessibility: Each message bubble should be announced with role, time and content. Cards should announce their title and description along with available actions (e.g. “Invest $200 button”). Suggestions should be accessible as buttons.
8. Animations and Haptics: Use spring animations when new messages appear or cards expand. Provide subtle haptic feedback when tapping send, selecting suggestions or interacting with cards.
9. Previews and Snapshots: Provide PreviewProviders for CopilotView, ChatMessageRow, and InputBar. Show states with multiple messages, cards and suggestions across light/dark modes and different dynamic type sizes.
10. Tests: Write unit tests to verify that send(_:) correctly appends messages and that generateMockResponse() adds an assistant message. Snapshot tests should cover the chat interface under various scenarios.

⸻

Design Requirements

• Feel Intelligent, Not Chatty: The Copilot should feel like a CFO assistant, not a friend. Avoid cutesy avatars or typing indicators. Use calm, professional styling. Assistant bubbles may have a soft gradient or glass effect to distinguish them.

• Focus on Actionable Content: Messages should lead to actions or insights. When presenting data, use clear wording (“Your spending on groceries is up 12% this month”) and offer next steps (“Set a budget”, “Find cheaper stores”).

• Use Cards for Structured Data: When the AI suggests something (e.g. invest, pay, cancel), present it in a card with a call to action. Cards should include small charts or progress rings only when they help answer a question.

• Suggestions Are Contextual: Suggestions should adapt to the last conversation. For now, they can be randomly selected or time‑based (morning vs evening). The design should make suggestions look secondary compared to user input.

• Adaptive Layout: On larger screens (iPad/Mac), display messages in a wider column with more generous spacing. Consider adding a split view where conversation is on one side and a summary panel (e.g. top insights) on the other, but do not implement it now—plan for it.

⸻

Performance

• Use LazyVStack within a ScrollView or List to load only visible messages. Use ScrollViewReader to scroll to the bottom after sending messages.

• Avoid storing heavy objects (e.g. images) in each ChatMessage. If future cards require images, load them asynchronously.

• Use @StateObject for view models and avoid unnecessary re‑bindings.

⸻

Accessibility

• Provide accessibilityLabel and accessibilityValue for each message bubble and card. Announce actions on cards.

• Support dynamic type: text in bubbles and cards must scale appropriately.

• Respect “Reduce Motion”: avoid complex animations when the setting is enabled.

• Ensure that VoiceOver reads messages in chronological order and that tapping a message provides context (“Assistant message at 9:41 AM: You spent 23% less eating out this week”).

• Test with Voice Control to make sure elements are tappable via voice commands.

⸻

Testing

• Unit Tests: Test that ConversationViewModel.send(_:) appends a user message and triggers a mock assistant reply. Test suggestion selection populates input or triggers responses.

• Snapshot Tests: Verify that messages, cards and suggestions render correctly in light and dark mode, across dynamic type sizes.

• UI Tests: Simulate typing a message, sending it and verifying that an assistant message appears. Test tapping a suggestion and the voice button placeholder.

⸻

Documentation

Create /docs/architecture/AI.md to explain the AI Copilot architecture:

• Describe the roles (user, assistant, system) and how they map to UI.

• Explain the message model, card system and suggestion mechanism.

• Document how the mock service generates responses and how to replace it with real AI in future phases.

• Provide guidelines on adding new card types or suggestions.

Record significant decisions (e.g. choice of using custom chat vs. built‑in Messages style, how messages are stored) in DECISIONS.md.

⸻

Completion

When this phase is complete:

• Run the app and interact with the Copilot. Send messages, select suggestions, and observe mocked assistant responses. Ensure the experience feels polished, professional and responsive.

• Summarize the Copilot implementation, noting any design challenges or future improvements (e.g. conversation persistence, context awareness).

• Update DECISIONS.md with the major architectural choices.

After summarizing and documenting, do not begin Phase 06. Wait for review and approval.

⸻

Do not begin the next phase, even if you believe there is remaining context. Your job is to complete only this phase, verify it builds cleanly, update DECISIONS.md with any architectural decisions, summarize the work performed, and wait for further instructions.
