# Pilot Interactive Simulator Experience

## Purpose
The Pilot Interactive Simulator exists on the landing page to instantly prove the "AI CFO" value proposition. 

Instead of showing visitors passive screenshots or a generic feature list, the simulator lets them immediately experience the product. It demonstrates how Pilot understands data, suggests actions, automates workflows, and builds trust—all before the user ever downloads the app. It transitions the website from "describing" Pilot to "feeling" like Pilot.

## Modes

The simulator operates in two distinct modes:

### 1. Guided Tour
* **What it is:** A 36-second cinematic, hands-off storyboard.
* **When it is shown:** This is the default view. On mobile devices (viewports under 768px), this is the *only* view shown to prevent frustrating scroll overlap and tap-target issues within the CSS phone frame.
* **Why it exists:** To passively hook visitors with an emotional narrative about financial intelligence that never sleeps.

### 2. Explore Yourself
* **What it is:** An interactive, state-driven miniature version of the Pilot app built in Vanilla JS.
* **When it is shown:** Triggered manually via the toggle above the phone on desktop and tablet views.
* **Why it exists:** To let high-intent users test the mechanics (navigating, automating, borrowing) and see the immediate cause-and-effect of the AI Command Center.

## State Model

The interactive simulator runs on a global Javascript `appState` object that mirrors the core metrics of the real iOS application:
* `balance`: Total aggregated cash (e.g., $14,250).
* `trust`: The Pilot Trust Score (e.g., 842).
* `health`: The Financial Health index (e.g., 92).
* `runway`: Cash Runway in months (e.g., 4.2).
* `transactions`: Array of mocked recent transactions.
* `automations`: Array of active "If This, Then That" rules.
* `lending eligibility`: Tracked dynamically by balance and trust triggers.

## User Actions

The interactive mode currently supports the following actions:
* **Navigate Tabs:** Users can tap the bottom navigation bar to seamlessly slide between the Command Center, Money, Trust, Automations, and Pilot Credit tabs.
* **Open Insight Modal:** Tapping the high-bill warning on the Command Center opens an iOS-style bottom sheet.
* **Automate Plan:** Confirming the insight action clears the warning and pushes a new rule to the `automations` array.
* **Update Trust Score:** Executing the automation triggers a state update and a haptic CSS bump, increasing the Trust Score (842 -> 845).
* **Withdraw Pilot Credit:** Tapping "Withdraw" in the Lending tab opens a confirmation modal.
* **Update Balance & Runway:** Confirming the withdrawal instantly adds $1,000 to the `balance`, adds a new Pilot Credit entry to `transactions`, and extends the `runway`.
* **Update Money & Command Center tabs:** Values are synchronized across all views upon any state change.

## Narrative Loop (Guided Tour)

The Guided Tour follows a strict 36-second timeline:
1. **Morning Briefing:** Shows the user's dashboard (Health, Cash Runway, Trust Score).
2. **AI Insight:** Pilot slides up an alert noting the electric bill is high.
3. **User Action:** The "Create payment plan" button scales down to simulate a user tap.
4. **Automation Created:** The alert vanishes, and an automation rule block fades in confirming the new logic.
5. **Trust Increase:** The Trust Score pulses (haptic bump) and ticks up from 842 to 845.
6. **Credit Unlock:** A dark, sleek Pilot Credit card fades in, offering $1,000 instantly.
7. **Next Morning Brief:** Transitions to "Tomorrow Morning" with updated stats (Health 95, Runway 5.0).
8. **Daily Brief:** Slides in a widget summarizing yesterday's AI actions (Overdraft prevented, bill automated, Trust increased, money saved).
9. **Cinematic Finale:** Fades to a quote ("Pilot works while you live your life. Financial intelligence that never sleeps.") and then ends on the Pilot logo and tagline before looping.

## Relationship to SwiftUI App

**This simulator is now the behavioral north star for the real iOS AI Command Center.** 

The iOS implementation must reproduce these exact user-visible behaviors—the proactive insights, the Trust Score bumps, the automation generation, and the immediate state synchronization—using native SwiftUI state, Observation models, abstracted services, and modern navigation paradigms. The website and the app will evolve together in parallel.

## Future Improvements

As the product matures, the landing page simulator should be upgraded with:
* real SwiftUI screen recording fallback
* backend waitlist integration
* full app demo mode
* interactive investor walkthrough
* analytics for simulator interactions
* mobile-safe interactive mode later
