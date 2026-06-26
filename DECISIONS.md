DECISIONS.md

Pilot Architectural Decision Record (ADR)

This document preserves the reasoning behind major architectural decisions.

It is not a changelog.

It is not a commit history.

It exists to explain why important decisions were made so future contributors (human or AI) understand the intent behind the architecture.

⸻

Rules

Whenever a decision significantly affects:

* architecture
* data models
* navigation
* persistence
* networking
* AI behavior
* security
* performance
* dependencies
* project organization

append a new ADR entry.

Do not rewrite previous decisions.

If a decision changes, create a new entry explaining why the previous decision was superseded.

Historical context is valuable.

⸻

Entry Format

⸻

ADR-000

Date

YYYY-MM-DD

Status

Accepted

Superseded

Deprecated

Experimental

Decision

A concise summary of the decision.

Context

What problem were we trying to solve?

What constraints existed?

Why was this decision necessary?

Alternatives Considered

List the realistic alternatives.

Explain why they were rejected.

Decision

Describe the chosen solution.

Avoid implementation details.

Focus on architecture.

Consequences

Positive outcomes.

Tradeoffs.

Future implications.

Implementation Notes

Optional.

Useful implementation guidance.

⸻

ADR-001

Date

2026-06-26

Status

Accepted

Decision

Pilot is an AI Financial Operating System rather than a traditional banking application.

Context

The original P3 project focused primarily on lending.

During planning it became clear that lending represents only one aspect of a person’s financial life.

Building a broader operating system allows lending to become a capability rather than the primary product.

Alternatives Considered

• Continue building only a lending platform.

• Build a traditional neobank.

• Focus exclusively on investing.

Decision

Pilot will become the intelligence layer connecting every aspect of a user’s financial life.

Banking, investing, lending, savings, automation, trust scoring, and AI assistance all exist under one unified experience.

Consequences

Positive

• Larger product vision

• Greater long-term differentiation

• Easier future expansion

Tradeoffs

• Increased architectural complexity

• Broader product scope

Implementation Notes

All future modules should assume they are components within a financial operating system rather than standalone products.

⸻

ADR-002

Date

2026-06-26

Status

Accepted

Decision

Adopt a native Apple-first architecture.

Context

Pilot is intended to feel like a first-party Apple application.

Consistency, accessibility, and long-term maintainability outweigh cross-platform abstraction.

Alternatives Considered

UIKit

React Native

Flutter

Compose Multiplatform

Decision

Use:

SwiftUI

SwiftData

Observation

Async/Await

Structured Concurrency

Native Apple frameworks whenever possible.

Consequences

Positive

• Native performance

• Better accessibility

• Lower maintenance

• Excellent Apple ecosystem integration

Tradeoffs

• Apple-only implementation

Implementation Notes

Avoid introducing third-party UI frameworks unless a compelling technical reason exists.

⸻

ADR-003

Date

2026-06-26

Status

Accepted

Decision

AI should be proactive instead of reactive.

Context

Most financial applications require users to discover insights themselves.

Pilot should reduce cognitive load by surfacing important information automatically.

Alternatives Considered

Traditional chatbot

Search interface

Manual reports

Decision

The AI should notice patterns, identify risks, recommend actions, and automate repetitive financial tasks whenever appropriate.

Consequences

Positive

Creates a product that feels substantially different from existing fintech applications.

Tradeoffs

Requires stronger notification, prioritization, and personalization systems.

⸻

Future Decisions

Examples of decisions that belong here include:

• Authentication architecture

• Offline-first strategy

• Financial institution aggregation provider

• AI provider selection

• Encryption model

• Data synchronization

• Trust Score calculation

• Lending architecture

• Widget architecture

• Plugin system

• Automation engine

• Notification framework

• Performance optimizations

• Modularization strategy

• Cross-device synchronization

If a future developer wonders “Why was this designed this way?”, the answer should be in this document—not buried in Git history.
