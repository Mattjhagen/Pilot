The structure should remain modular as the application grows.

⸻

Build

Create:

• App entry point

• Dependency container

• Environment objects

• Navigation coordinator

• Application state

• Theme manager

• Typography

• Spacing system

• Color system

• Animation system

• Haptics manager

• Logging service

• Configuration service

• Error handling

• Reusable loading states

• Reusable empty states

• Reusable buttons

• Cards

• Sheets

• Glass components

• Navigation transitions

• Preview infrastructure

• Mock services

• Development flags

⸻

Design Requirements

The interface should feel:

• Native Apple

• Minimal

• Premium

• Fast

• Calm

• Thoughtful

Avoid visual noise.

Avoid unnecessary decoration.

Every component should be reusable.

⸻

Performance

Prefer value types.

Avoid unnecessary Observable objects.

Minimize MainActor work.

Prepare for offline-first architecture.

Support future synchronization.

⸻

Accessibility

Support:

• VoiceOver

• Dynamic Type

• Reduce Motion

• High Contrast

• Keyboard navigation

• Pointer interaction

Accessibility should be considered from the beginning—not added later.

⸻

Testing

Configure:

• Swift Testing

• Snapshot testing architecture

• Dependency injection for testability

• Preview mocks

• Testing utilities

The project should be easy to test before any features are added.

⸻

Documentation

After implementation:

Update DECISIONS.md with every architectural decision made.

Document why major patterns were chosen.

Do not simply document what was built.

Document why it exists.

⸻

Completion

When this phase is complete:

Do not continue to Phase 02.

Instead:

Summarize the completed architecture.

Identify any weaknesses.

Suggest improvements.

Wait for approval before beginning the next phase.

The quality of the foundation determines the quality of every future phase.

⸻

Do not begin the next phase, even if you believe there is remaining context. Your job is to complete only this phase, verify it builds cleanly, update DECISIONS.md with any architectural decisions, summarize the work performed, and wait for further instructions.
