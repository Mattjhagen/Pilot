# AI Experience (Pilot v2 Flagship)

## Overview
The AI Command Center is the beating heart of Pilot. It is not a dashboard; it is a dynamic, intelligent surface that synthesizes the user's entire financial life into a single, proactive interface. It is the first screen the user sees, and it must immediately convey trust, competence, and clarity. 

This document serves as the definitive product specification for Pilot’s flagship experience.

---

## 1. Pilot Personality

*   **Voice:** Pilot speaks like a calm, highly intelligent, optimistic, and proactive Chief Financial Officer. It uses simple, direct language. No jargon, no alarmist tones.
*   **Writing Style:** Concise. Sentences are short and actionable. It favors active voice (e.g., "I staged a transfer for your upcoming bill" instead of "A transfer was staged").
*   **Notification Style:** Ephemeral and contextual. It interrupts only when necessary or highly beneficial. 
*   **Recommendation Style:** Confident but suggestive. Pilot recommends the best path but always leaves the final tap to the user. "I recommend moving $500 to savings" rather than "You should save $500."
*   **Conversational Personality:** Respectful, encouraging, and unbothered by financial distress. It never judges a user's spending habits; it simply presents the reality and plots a path forward.

---

## 2. Command Center Layout

The exact visual hierarchy of the home screen, from top to bottom:

1.  **AI Daily Briefing (Top Header):** A fluid, persistent but dismissible text-based greeting and briefing that shifts based on the time of day.
2.  **Live Cards (Dynamic Area):** Active, real-time events that require attention right now (e.g., "Dispute in progress", "Transfer arriving in 2 hours"). This area is invisible if empty.
3.  **Financial Health & Runway Hero (Main Focus):** The largest, most beautiful component. Synthesizes Runway and Health into a single holistic view. Always visible.
4.  **AI Recommendations (The Copilot):** A horizontally scrolling carousel of proactive suggestions. Collapsible if the user wants to focus.
5.  **Widget Grid (Modular):** A customizable grid of 2x2 or 4x2 widgets (Spending, Trust, Upcoming Bills, etc.). Users can reorder these, but Pilot suggests the optimal layout.
6.  **Financial Timeline (Bottom Feed):** An infinite scroll chronologically detailing past, present, and predicted future events.

---

## 3. Core Experiences

### 3.1 Financial Health Engine
*   **Purpose:** To provide a single, irrefutable measure of the user's overall financial stability, moving beyond simple bank balances.
*   **User Emotion:** Clarity and security. The feeling of finally knowing exactly where they stand.
*   **Primary UI Layout:** A beautiful, glowing orb or organic shape that subtly pulses. The color shifts based on the state (e.g., calm blue/green for optimal, warm amber for attention).
*   **Micro-interactions and Animations:** The shape gently breathes while idle. When the user takes a positive action, the shape expands slightly and glows brighter.
*   **Empty State:** A subtle, translucent outline of the shape with text: "Connecting your accounts to calculate your health."
*   **Loading State:** The shape forms gradually, pulling in particles representing different data sources.
*   **Error State:** A frosted glass overlay with a gentle retry button: "Unable to reach your bank. Tap to reconnect."
*   **Accessibility Considerations:** Use high-contrast text overlays and ensure the state is clearly stated in text, not just color (e.g., "Health: Optimal").
*   **AI Behavior:** The AI analyzes liquidity, debt-to-income, savings rate, and upcoming liabilities to calculate this score dynamically.
*   **Future Production Behavior vs Mock Behavior:** Mock behavior uses a static state. Production will use real-time webhooks and daily ML inference on transaction streams to adjust the score.
*   **Financial Health vs. Trust Score:** Financial Health measures your *current financial reality* (liquidity, debt, runway). Trust Score measures your *behavior and reliability within Pilot* (consistency, honoring commitments), which unlocks lending products.

### 3.2 AI Daily Briefing
*   **Purpose:** To contextualize the user's finances at the right time, reducing the need for constant app checking.
*   **User Emotion:** Preparedness and relief.
*   **Primary UI Layout:** A soft, frosted glass banner at the very top of the Command Center. Clean typography, no clutter.
*   **Micro-interactions and Animations:** Text fades in smoothly character by character, simulating Pilot "speaking."
*   **Empty State:** N/A (There is always a greeting).
*   **Loading State:** A subtle shimmer effect across the text area.
*   **Error State:** Falls back to a simple time-based greeting: "Good morning."
*   **Accessibility Considerations:** Fully readable by VoiceOver, maintaining the conversational tone.
*   **AI Behavior:** 
    *   **Morning Briefing:** Focuses on the day ahead (upcoming bills, daily budget).
    *   **Evening Recap:** Summarizes the day (money spent, anomalies detected).
    *   **Weekly Review:** A larger Friday/Sunday recap of trends.
    *   **Monthly Report:** A deep dive into net worth changes.
    *   **Celebration Moments:** "You hit your savings goal! Incredible work."
    *   **Warning Moments:** "You're trending to overdraft by Thursday. Let's move some funds."
*   **Future Production Behavior vs Mock Behavior:** Mock will use localized time and hardcoded strings. Production uses LLMs to generate personalized, context-aware natural language briefings based on the user's specific data graph.

### 3.3 Cash Runway
*   **Purpose:** To translate balances into time. Telling a user how many days they can survive without a new paycheck.
*   **User Emotion:** Certainty and control.
*   **Primary UI Layout:** A bold, prominent numerical display (e.g., "42 Days") integrated visually with the Financial Health Hero.
*   **Micro-interactions and Animations:** The number counts up or down smoothly when the underlying data changes.
*   **Empty State:** "Waiting for income data..."
*   **Loading State:** The number cycles rapidly before landing on the correct value.
*   **Error State:** Displays "Runway Unavailable" with a subtle warning icon.
*   **Accessibility Considerations:** Large, legible dynamic type.
*   **AI Behavior:** Predicts future expenses based on recurring bills and historical discretionary spending to calculate the exhaustion date of liquid cash.
*   **Future Production Behavior vs Mock Behavior:** Mock will use a static algorithm. Production will use time-series forecasting to predict the exact date liquidity hits zero.

### 3.4 Trust Score
*   **Purpose:** A transparent, behavioral credit system that empowers the user to unlock Pilot's premium features and lending capabilities.
*   **User Emotion:** Motivation and empowerment.
*   **Primary UI Layout:** A fluid, animated circular gauge that visually "fills up."
*   **Micro-interactions and Animations:** The ring glows and emits subtle particles when the score increases. Tapping it reveals exactly what actions will increase the score next.
*   **Empty State:** "Begin building Trust with your first deposit."
*   **Loading State:** The ring spins smoothly while fetching the score.
*   **Error State:** Displays last known score with a subtle "offline" indicator.
*   **Accessibility Considerations:** The score is announced distinctly, and the progress to the next tier is clearly stated.
*   **AI Behavior:** The AI monitors habits, not just balances. It identifies positive patterns (consistent savings, paying bills early) and translates them into Trust points.
*   **Future Production Behavior vs Mock Behavior:** Mock will be a hardcoded number. Production will use a complex rules engine and behavioral models to adjust the score in real-time.

### 3.5 AI Recommendations
*   **Purpose:** To do the financial heavy lifting for the user.
*   **User Emotion:** Relief. The AI is doing the work.
*   **Primary UI Layout:** A horizontal scrolling carousel of distinct, actionable cards.
*   **Micro-interactions and Animations:** Cards slightly scale up on tap. When an action is taken, the card folds away gracefully.
*   **Empty State:** "You're all caught up. No new recommendations right now."
*   **Loading State:** Skeleton cards shimmering.
*   **Error State:** The carousel simply hides itself to prevent clutter.
*   **Accessibility Considerations:** Ensure swipe gestures are easily performed or have button alternatives for navigation.
*   **AI Behavior:** Contextual generation of insights. E.g., identifying a subscription price increase, or noticing excess liquidity that should be invested.
*   **Future Production Behavior vs Mock Behavior:** Mock will show static recommendations. Production will generate these asynchronously using LLMs and trigger them via push notifications.

### 3.6 Financial Timeline
*   **Purpose:** A chronological feed of past, present, and future financial events, embedding recommendations naturally.
*   **User Emotion:** Omniscience. Total visibility into the flow of money.
*   **Primary UI Layout:** A vertical feed. Past events are slightly dimmed. The present day is highlighted. Future predicted events are styled uniquely (e.g., dashed outlines).
*   **Micro-interactions and Animations:** Scrolling past the "Today" marker triggers a subtle haptic bump.
*   **Empty State:** "Connect an account to see your timeline."
*   **Loading State:** A shimmering vertical line with skeleton items.
*   **Error State:** "Unable to load timeline."
*   **Accessibility Considerations:** Clear delineation between past and future items for screen readers.
*   **AI Behavior:** The AI predicts future recurring transactions and injects "smart" items into the timeline (e.g., "Predicted: High Energy Bill Next Week").
*   **Future Production Behavior vs Mock Behavior:** Mock shows a hardcoded list. Production dynamically interleaves real cleared transactions with ML-predicted future transactions.

### 3.7 One-Tap Actions
*   **Purpose:** To make financial execution effortless.
*   **User Emotion:** Power and speed.
*   **Primary UI Layout:** Contextual buttons integrated directly into Recommendations or the Timeline (e.g., "Move $500", "Cancel Subscription").
*   **Micro-interactions and Animations:** Button morphs into a loading spinner, then a checkmark, accompanied by a satisfying haptic click.
*   **Empty State:** N/A (Actions are only shown when available).
*   **Loading State:** Inside the button itself (spinner).
*   **Error State:** Button turns red and gently shakes.
*   **Accessibility Considerations:** Large tap targets, clear action verbs.
*   **AI Behavior:** The AI determines which action is most probable and presents it as the primary default.
*   **Future Production Behavior vs Mock Behavior:** Mock simulates the state change. Production actually executes money movement via banking APIs.

### 3.8 Live Cards
*   **Purpose:** For active, ongoing financial situations that need temporary, high-visibility real estate.
*   **User Emotion:** Reassurance. Pilot is on the case.
*   **Primary UI Layout:** High-contrast, dynamic widgets near the top of the Command Center.
*   **Micro-interactions and Animations:** Progress bars update in real-time. The card smoothly slides in when created and slides out when resolved.
*   **Empty State:** N/A (Hidden if not needed).
*   **Loading State:** Shimmering content within the card.
*   **Error State:** "Status update delayed."
*   **Accessibility Considerations:** Announces status changes dynamically.
*   **AI Behavior:** The AI monitors long-running processes (like a dispute or a multi-day ACH transfer) and updates the user automatically.
*   **Future Production Behavior vs Mock Behavior:** Mock uses a timer. Production uses websockets or polling to reflect real-world status.

---

## 4. Widget System

Widgets are the building blocks of the personalized Command Center.

*   **Financial Health:** The hero orb displaying overall status.
*   **Trust:** The circular gauge showing Trust Score and progress.
*   **Cash Runway:** Bold numerical display of days remaining.
*   **Spending:** A minimalist bar chart showing spending pacing vs. typical month.
*   **Upcoming Bills:** A compact list of the next 3 scheduled liabilities.
*   **Investments:** A clean sparkline showing portfolio performance.
*   **AI Recommendations:** The contextual carousel (can be pinned).
*   **Lending:** Active Pilot credit lines and utilization.
*   **Goals:** Progress rings toward user-defined savings goals.
*   **Net Worth:** A historical trendline of total assets minus liabilities.
*   **Subscriptions:** A counter of active subscriptions and total monthly cost.

---

## 5. Motion Design

Every interaction reinforces Pilot's premium, intelligent nature.

*   **App Launch:** The Command Center doesn't just appear; it *assembles*. The Financial Health orb fades in, followed by the Daily Briefing typing out, and the widgets smoothly sliding up into place. (Duration: 0.6s, Spring Easing).
*   **Widget Tap (Expand):** Tapping a widget smoothly expands it to full screen, using a shared element transition. The background dims. (Duration: 0.4s, Fluid Spring).
*   **Action Execution (One-Tap):** When a user confirms an action, the button morphs into a checkmark, followed by a crisp haptic 'pop', and the associated card folds inward and disappears. (Duration: 0.3s, Snappy).
*   **Scrolling the Timeline:** As the user scrolls from 'Past' into 'Future', the background tint subtly shifts, and a physical-feeling haptic bump occurs exactly as the "Today" line crosses the center of the screen.

---

## 6. Investor Demo Flow

The perfect 5-minute showcase of Pilot’s value.

1.  **The Hook (0:00 - 1:00):** Open the app. The AI Command Center assembles. The Financial Health orb is glowing. The Morning Briefing types out: "Good morning. Runway is 45 days. You have $1,200 in excess liquidity this week."
2.  **The AI Magic (1:00 - 2:00):** Swipe to the AI Recommendations. Tap "Invest Excess Liquidity." The One-Tap action instantly moves the money with Face ID. The card folds away. The Financial Health orb subtly glows brighter.
3.  **The Time Machine (2:00 - 3:00):** Scroll down to the Financial Timeline. Scroll past today into the future. Show how Pilot has predicted a large car insurance payment next week and has automatically suggested a plan to cover it.
4.  **The Trust Engine (3:00 - 4:00):** Tap the Trust Widget. Show how consistent habits have unlocked "Pilot Credit." Accept a 0% interest advance to smooth out cash flow for the upcoming insurance payment.
5.  **The Close (4:00 - 5:00):** Show the Evening Briefing seamlessly updating: "Your cash flow is secured for the week. You are on track for your yearly goals. Rest easy." The screen dims. The investor feels that money finally manages itself.
