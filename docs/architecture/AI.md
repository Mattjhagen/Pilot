# Pilot AI Copilot Architecture

## Philosophy

The Copilot serves as a financial "Jarvis" within the app. It's designed to be:
- **Professional**: Calm aesthetics avoiding "cutesy" or overly chatty personas.
- **Action-Oriented**: Provides proactive insights and structured interactive cards instead of plain text dumps.
- **Contextual**: Analyzes user behavior and suggests next steps.

## Components

### Data Models
Located in `AICopilotModels.swift`.
- `ChatMessage`: The foundational model for all chat messages. Identifies its `MessageRole`.
- `CopilotCard`: An `enum` allowing structured rendering for complex responses (e.g., `.insight`, `.recommendation`, `.alert`). 
- `CopilotSuggestion`: Time/context-sensitive prompt bubbles.

### Service Layer
`CopilotService` (currently mocked via `CopilotMockService`) handles generating intelligent responses. It utilizes `Task.sleep` to mimic inference/network latency. This will be replaced with real AI generation endpoints in later phases.

### View Model
`ConversationViewModel` manages the active session.
- Holds the in-memory array of `messages` and `suggestions`.
- Exposes `send(_:)` and `selectSuggestion(_:)` which mutate the array and subsequently call `generateMockResponse()` to fetch a simulated assistant reply.

### Chat Interface
- `CopilotView`: The main container. Uses a `ScrollViewReader` to automatically scroll the UI up when new messages arrive or the keyboard appears.
- `ChatMessageRow`: Renders bubbles. Distinguishes between User (Right-aligned, accent color) and Assistant (Left-aligned, surface color). Automatically unpacks and renders a `CopilotCard` if one is present on the message.
- `InputBar` and `SuggestionsBar`: Provide easy interaction surfaces, including a voice button placeholder.

## Storage Note
Currently, the conversation is strictly in-memory (per ADR-010). Persistence (e.g., SwiftData or Cloud Sync) will be introduced in subsequent phases.
