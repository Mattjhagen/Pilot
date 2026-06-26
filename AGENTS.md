AGENTS.md

Pilot Engineering Constitution

This document defines the non-negotiable engineering and product principles for Pilot.

Every implementation decision should follow these rules.

⸻

Mission

Pilot is an AI-powered Financial Operating System.

Pilot is NOT a banking app.

Pilot is NOT a budgeting app.

Pilot is NOT a chatbot.

Pilot exists to reduce financial stress by helping people make better financial decisions through intelligent software.

Banking is one capability.

The operating system is the product.

⸻

Core Philosophy

Pilot should feel like:

* Apple designed a financial operating system.
* Money manages itself.
* The user is always one step ahead.
* Calm, intelligent, proactive.

Pilot should never feel like spreadsheets wrapped inside an app.

⸻

The AI Is NOT ChatGPT

The AI should behave like a trusted Chief Financial Officer.

The AI should:

Notice

Predict

Recommend

Protect

Automate

Teach

The AI should be proactive whenever possible.

The AI should rarely wait for the user to ask.

⸻

Engineering Philosophy

Always choose:

Simple

Maintainable

Predictable

Modular

Composable

Native

Readable

Avoid clever code.

Future developers should immediately understand every implementation.

⸻

Technology Stack

SwiftUI

SwiftData

Observation

Async/Await

Structured Concurrency

Swift Testing

Feature-based architecture

Protocol-oriented programming

Dependency Injection

Native Apple frameworks

Avoid UIKit unless absolutely required.

Avoid unnecessary third-party dependencies.

⸻

Architecture Rules

Every feature should be independently testable.

Business logic never belongs inside Views.

Views should display state.

ViewModels manage presentation logic.

Services contain business logic.

Repositories handle persistence.

Networking should remain isolated.

Never tightly couple modules.

⸻

Product Rules

Every feature must answer at least one of these questions:

Does it save time?

Does it reduce stress?

Does it improve financial decisions?

Does it increase trust?

Does it automate work?

If the answer is no, question whether the feature belongs.

⸻

UI Rules

Design for clarity first.

Minimalism over decoration.

Whitespace is intentional.

Motion should communicate state.

Animations should never distract.

Support:

Dark Mode

Light Mode

Dynamic Type

VoiceOver

Reduce Motion

Accessibility is not optional.

⸻

Performance Rules

Scrolling should remain smooth.

Avoid unnecessary rendering.

Avoid expensive View recomputation.

Prefer lazy loading.

Optimize battery usage.

Avoid blocking the MainActor.

⸻

Security Rules

Security is a feature.

Never commit:

API keys

Secrets

Tokens

Passwords

Certificates

Production credentials

Use:

Keychain

Secure Enclave

Face ID

Biometric authentication

Least privilege

Privacy by default.

⸻

AI Guardrails

Never fabricate financial information.

Never invent account balances.

Never generate fake transactions.

Never simulate real financial data without clearly indicating that it is demo data.

Never make promises about investments.

Never predict investment returns.

Always explain uncertainty.

⸻

Financial Guardrails

Pilot assists.

Pilot does not replace professional legal, tax, or financial advice.

Never hide fees.

Never manipulate users.

Never create dark patterns.

Always favor transparency.

⸻

Code Quality

No TODO placeholders.

No dead code.

No duplicated logic.

No giant files.

Prefer reusable abstractions.

Keep functions focused.

Prefer composition over inheritance.

Every commit should leave the project in a buildable state.

⸻

Refactoring Rules

Never rewrite working architecture simply because another pattern exists.

Prefer incremental improvements.

Avoid unnecessary rewrites.

Preserve public APIs whenever practical.

Discuss architectural changes before making sweeping modifications.

⸻

Dependencies

Before adding any dependency ask:

Can Apple frameworks already solve this?

Does this dependency reduce maintenance?

Is it actively maintained?

Is it worth the added complexity?

If uncertain, do not add it.

⸻

Project Roadmap

Features should generally be developed in this order.

1. Design System
2. Navigation
3. Dashboard
4. AI Copilot
5. Money
6. Trust
7. Goals
8. Automations
9. Notifications
10. Widgets
11. Financial Institution Connectivity
12. Investments
13. Lending Engine
14. Trust-Based Credit
15. Blockchain Anchoring (optional)

Do not skip ahead unless explicitly instructed.

⸻

Decision Framework

When multiple solutions exist:

Choose the one that:

reduces complexity

improves maintainability

keeps code modular

uses native Apple APIs

supports long-term scalability

⸻

If Requirements Are Ambiguous

Do not invent major features.

Do not redesign the product.

Extend existing architecture.

Follow established patterns.

Ask for clarification when uncertainty affects architecture.

⸻

The Golden Rule

Pilot should make users feel:

“I don’t have to worry about my money because Pilot is looking out for me.”

Every engineering decision should move the product toward that experience.
