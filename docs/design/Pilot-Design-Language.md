# Pilot Design Language (PDL)

## 1. Brand Philosophy

### What Pilot Should Feel Like
Pilot is a premium, AI-powered Financial Operating System. It should evoke the same feelings as stepping into a high-end luxury vehicle: the technology is incredibly advanced, but the experience is effortless, quiet, and perfectly tailored to the driver. 
Pilot feels like an ever-present, highly intelligent Chief Financial Officer who has everything under control.

### Emotional Keywords
*   Calm
*   Intelligent
*   Premium
*   Proactive
*   Effortless
*   Certain

### What Pilot Should NEVER Feel Like
*   **Never a spreadsheet:** Avoid dense tables and endless lists of numbers.
*   **Never a traditional bank:** Avoid sterile blues, cluttered marketing banners, and generic financial icons.
*   **Never a chatbot:** Pilot is not ChatGPT wrapped in an app. The AI is embedded into the interface, not a conversational overlay.
*   **Never alarming:** No aggressive red warnings unless money is actively disappearing.

### The AI Constitution (Pilot's Personality)
Pilot's personality is defined by strict behavioral rules that govern every interaction:
*   **Never overwhelm the user:** Present only what is immediately relevant.
*   **Never surface more than three recommendations at once:** Decision fatigue is the enemy of financial health.
*   **Never ask the user to interpret financial data:** The system does the math; the user makes the choice.
*   **Always translate data into decisions:** Don't say "Your spending is up 15%." Say "You have $150 less this week. Tap to adjust your savings goal."
*   **Always explain why a recommendation exists:** "I staged this transfer *because* your car insurance is due tomorrow."
*   **Confidence must match certainty:** Use appropriate language for predictions ("Likely," "High confidence," "Confirmed"). Do not present estimates as facts.

---

## 2. Design Principles

1.  **Calm over noisy:** Use negative space generously. Let the data breathe. If an element doesn't serve a direct purpose, remove it.
2.  **Information over decoration:** Do not use gradients or shadows simply to make things look "cool." Every styling choice must enhance readability or convey state.
3.  **AI should feel invisible:** The user shouldn't feel like they are interacting with an "AI feature." They should feel like the app simply *knows* what to do.
4.  **Motion should reinforce understanding:** Animations shouldn't just be pretty; they should explain where information came from and where it is going.
5.  **Every pixel should earn its place:** If a screen feels cluttered, it has failed. Reduce until you can reduce no more.

### Information Hierarchy Standard
Every screen across Pilot must follow this exact visual priority:
1.  **What matters right now:** The most critical action or insight (e.g., an overdraft warning, a pending transfer).
2.  **What will matter soon:** Upcoming events in the immediate future (e.g., bills due this week, predicted low runway).
3.  **Why it matters:** Context for the data presented (e.g., "This bill is 20% higher than last month").
4.  **What Pilot recommends:** The AI's suggested path forward (e.g., "Cancel subscription").
5.  **Everything else:** Static data, historical charts, and settings, accessible but out of the primary visual flow.

---

## 3. Moments of Delight

Pilot shouldn’t only work well—it should surprise and satisfy the user. These micro-interactions build long-term affinity.

*   **No Confetti. No Fireworks.** Pilot relies on calm satisfaction, not gamified noise.
*   **The Payoff:** When a loan or debt reaches $0, the balance smoothly evaporates or settles into a satisfying checkmark, accompanied by a heavy, reassuring haptic click.
*   **The Trust Build:** The Trust orb doesn't just fill; it subtly grows brighter and more vibrant over months of consistent positive behavior.
*   **The Breath of Stability:** When all finances are in optimal shape, the Financial Health orb gently "breathes" (a very slow, subtle scale loop).
*   **The Morning Arrival:** The AI Daily Briefing doesn't just pop onto the screen; it fades in smoothly, character by character, evoking the feeling of a freshly printed newspaper arriving each morning.

---

## 4. Color Language

The color palette expands beyond static tokens into intentional, semantic meaning.

### Surfaces
*   **Primary Surfaces:** Deep, rich blacks (`#000000`) in dark mode, stark white (`#FFFFFF`) in light mode. This provides maximum contrast for the content.
*   **Elevated Surfaces:** Used for standard cards. Subtle off-black (`#111111`) or off-white (`#F5F5F5`).
*   **Glass Surfaces:** For ephemeral overlays and the AI Daily Briefing. Highly blurred backgrounds with a semi-transparent overlay to ensure legibility while maintaining environmental context.

### Semantic Colors
*   **Success (Positive Flow):** Soft, minty greens. Used when runway increases, debts are paid, or trust scores rise. *Never use harsh neon greens.*
*   **Warning (Attention Needed):** Warm, muted ambers. Used for upcoming large bills or slightly elevated spending.
*   **Critical (Action Required):** Deep, saturated crimsons. Reserved *only* for overdrafts, failed payments, or active fraud. 

### Thematic Colors
*   **Trust Colors:** Ethereal, glowing cyans and deep blues. Represents the building of reputation within Pilot.
*   **Financial Health Colors:** A dynamic gradient that shifts from cool blue (Optimal) to warm amber (Attention) based on state.
*   **AI Colors:** Subtle, shifting iridescence (purples and soft pinks). Used very sparingly to indicate the system is "thinking" or to highlight a high-value recommendation.

---

## 5. Typography

Pilot uses a crisp, modern sans-serif (e.g., SF Pro or Inter) to ensure absolute legibility.

*   **Hero Numbers:** Bold, massive, and tightly tracked. Used for Cash Runway and Net Worth. (e.g., 64pt, Bold).
*   **Headlines:** Used for primary screen titles. (e.g., 34pt, Semibold).
*   **Dashboard Cards / Section Headers:** Used to title widgets and sections. (e.g., 20pt, Semibold).
*   **Body:** Used for the Daily Briefing and standard descriptions. (e.g., 17pt, Regular).
*   **Secondary Text:** For timestamps and subtle context. (e.g., 15pt, Regular, subtle gray).
*   **Labels:** All-caps, widely tracked text for small meta-information. (e.g., 11pt, Semibold, Uppercase).
*   **Monospace Values:** Essential for transaction IDs, account numbers, and any tabular financial data where vertical alignment is required. (SF Mono).

---

## 6. Spacing System

Pilot adheres strictly to an 8pt grid system.

*   **Micro (4pt):** Spacing between an icon and its label.
*   **Tight (8pt):** Spacing between related items in a list.
*   **Standard (16pt):** Standard padding inside cards and between related widgets.
*   **Loose (24pt):** Spacing between distinct conceptual sections.
*   **Macro (32pt+):** Spacing around hero elements and the bottom of scrolling lists.

---

## 7. Card System

*   **Standard Card:** Solid elevated background, 16pt corner radius, no shadow (relies on background contrast). Used for static settings or lists.
*   **Elevated Card:** Slight shadow (Y: 4, Blur: 12), 20pt corner radius. Used for interactive widgets.
*   **Glass Card:** Blurred background, thin 1px semi-transparent border, 24pt corner radius. Used for AI Recommendations and temporal alerts.
*   **Expandable Card:** Features a subtle chevron or affordance. Tapping initiates a shared-element transition to full screen.
*   **Live Card:** Features an active progress bar or pulsing indicator. Used for ongoing transfers or disputes.
*   **Hero Card:** The largest card, taking up the top third of a view. Used exclusively for Financial Health or major milestones.

---

## 8. Iconography

*   **System:** SF Symbols (or equivalent highly-refined icon set).
*   **Sizing:** Standardized to 24x24 for primary actions, 16x16 for inline contextual icons.
*   **Weights:** Regular weight for standard icons. Medium weight for active states.
*   **Custom Icon Strategy:** Future custom icons should mimic the stroke width of SF Symbols but introduce Pilot-specific metaphors (e.g., a stylized runway for Cash Runway, a unique emblem for Trust).

---

## 9. Motion Language

Motion is functional, not decorative.

*   **Springs over Ease:** Almost all animations use physics-based spring mechanics to feel physical and responsive, rather than linear easing.
*   **Number Animations:** Balances never just change; they count up or down smoothly (rolling odometers).
*   **Card Expansion:** Tapping a card expands it outward from the point of touch, pushing other elements away smoothly.
*   **Navigation:** Fluid transitions between tabs, avoiding harsh cuts.
*   **Loading:** Avoid traditional spinners. Use skeleton loaders that sweep with a soft gradient to imply data is flowing in.
*   **Haptics:** 
    *   *Light:* Scrolling past timeline milestones.
    *   *Medium:* Tapping a primary button.
    *   *Heavy:* Confirming a financial transaction.
*   **Timing:** Micro-interactions (toggles, button presses) should take ~150-250ms. Macro-transitions (screen changes) should take ~300-400ms.

---

## 10. Widget Language

*   **Financial Health:** The orb shape. Pulses gently.
*   **Trust:** A circular gauge. Fills clockwise.
*   **Cash Runway:** Massive hero typography with a subtle background graph.
*   **Spending:** Minimalist, horizontally stacked bar charts comparing current vs. average pacing.
*   **Upcoming Bills:** A vertical stack of standard cards, sorted chronologically.
*   **Investments:** A clean, borderless sparkline that flows across the widget.
*   **AI Recommendations:** Glass cards in a horizontal scrolling carousel.
*   **Lending:** A sleek progress bar indicating credit utilization.
*   **Goals:** Radial progress rings.
*   **Net Worth:** A smooth, curved trendline (no sharp points).
*   **Subscriptions:** A grid of logos with subtle red badges for price increases.

---

## 11. Empty States

*   **Philosophy:** An empty state is an opportunity to educate and onboard, not a dead end.
*   **Design:** A beautifully subtle icon, a concise explanation, and a single, clear Call-to-Action (CTA).
*   **Example:** "Connect your first account to see your Cash Runway." [Button: Connect Bank].

---

## 12. Loading States

*   **Philosophy:** Reduce perceived wait time.
*   **Strategy:** Use progressive loading. Show the UI shell (skeletons) immediately, then populate text, then populate imagery and complex charts last. The skeleton shimmer should be subtle, not distracting.

---

## 13. Charts

Charts must be instantly comprehensible.

*   **Spending / Cash Flow:** Bar charts with soft rounded corners.
*   **Trust:** Radial gauges with clear tier markers.
*   **Financial Health / Net Worth / Investments:** Smooth, Bezier-curved line charts (sparklines). Remove all grid lines and axes unless the user explicitly taps/holds to inspect data. Fill the area under the line with a very subtle, fading gradient.

---

## 14. AI Presentation

*   **Philosophy:** Pilot does not chat. It executes and reports.
*   **Visuals:** AI suggestions appear as actionable cards in the stream of consciousness (Timeline or Recommendations carousel). 
*   **Actionable:** Every AI insight *must* have an action attached. E.g., "You spent $200 less on groceries. [Move to Savings]".
*   **Never ChatGPT:** No chat bubbles, no typing indicators for long essays, no conversational UI.

---

## 15. Accessibility

*   **Dynamic Type:** All text must scale perfectly without breaking the layout. Cards must expand vertically if text grows.
*   **VoiceOver:** Custom traits for widgets. A chart shouldn't just say "image"; it should read out the summary: "Spending trend is down 5% this week."
*   **Contrast:** Ensure all text passes WCAG AA standards. Glass surfaces must ensure background blur is strong enough to maintain text contrast regardless of what is behind it.
*   **Reduce Motion:** Respect the OS setting. Convert spring animations to fast crossfades.
*   **Color Blindness:** Never use color alone to convey state. Success/Warning/Critical must be accompanied by specific icons and clear text.

---

## 16. Future Design Direction (The Experience Architecture)

Pilot is shifting away from feature-based "Phases" into **Experiences**. Every future addition must snap into one of these core experiences and be refined until it feels world-class.

*   **AI Experience:** The proactive engine, recommendations, and briefings.
*   **Financial Health Experience:** Runway, holistic health, and stability metrics.
*   **Money Experience:** Checking, routing, and transactional flow.
*   **Lending Experience:** Pilot credit lines, advances, and payoff paths.
*   **Trust Experience:** Reputation building, score, and unlocked capabilities.
*   **Automation Experience:** Rules, scheduled transfers, and autonomous money movement.

Every pixel we build must reinforce these core experiences to ensure Pilot feels like a cohesive operating system, not a loosely connected dashboard.
