• TrustScore: struct with overall score (numeric and letter grade), trend, last updated date and perhaps a color/state indicator.

• TrustMetric: struct with name, current value (0–100 or similar), weight (0–1), trend, and description. Include any fields necessary for charts (e.g. history points).

• TrustHistory: struct representing the score over time (e.g. array of (date, score) tuples).

• TrustSuggestion: struct with a message, related metric and priority. The view model will expose suggestions to the UI.

• TrustMockService: returns a sample TrustScore and an array of TrustMetrics with synthetic values. It also returns TrustHistory and an array of TrustSuggestions. Provide deterministic sample data for tests and randomized data for previews if needed.

• TrustOverviewViewModel: fetches trust data from the mock service on init and publishes TrustScore, [TrustMetric], TrustHistory and [TrustSuggestion] for the overview. Handles navigation to detail views.

• TrustMetricDetailViewModel: takes a TrustMetric and exposes its history and tips. Optionally calculates improvement goals.

⸻

Build

1. Mock Data and Service: Implement TrustMockService. Define sample values for each metric (e.g. Income Stability = 75, Savings Habits = 60). Define weights (e.g. Income Stability weight = 0.2). Provide a history for the overall score and each metric (e.g. month over month values). Provide sample suggestions (“Set up direct deposit to improve income stability”, “Increase emergency fund to 3 months of expenses”).
2. Overview View and Score Card: Build TrustOverviewView as a scrollable view. At the top, place TrustScoreCard that displays the overall score with a radial gauge or large number, the score’s letter grade, and a brief description of what the score represents. Use color coding to indicate general tiers (green = good, yellow = average, orange/red = needs improvement) but avoid shaming; use supportive language. Add an indicator showing the change since last month (“+12 points since May”).
3. Metric List/Rows: Below the score card, list each TrustMetric using TrustMetricRow or TrustMetricCard. Each row shows the metric’s current value, an icon, a trend arrow, and a short tip. Rows are tappable to navigate to detail views via the navigation router from Phase 03.
4. Metric Detail View: Implement TrustDetailView that displays a deeper explanation of the metric, a simple line chart of its historical values (use Charts or custom shapes), and an ImprovementTipsView listing actionable suggestions. Provide “Learn More” links or footnotes to trustworthy financial education resources (static pages or placeholders).
5. Trust History Chart: Optionally, include a summary chart on the overview screen showing the overall Trust Score over time. Use a simple LineChart or AreaChart with tooltips disabled for simplicity. Highlight the current score and compare it to last month.
6. Improvement Tips: Implement ImprovementTipsView that receives an array of TrustSuggestion and displays them in a vertical list. Each item should include a short description and, if relevant, a link to the corresponding metric detail or action (e.g. open Money screen to set up automatic transfers). Suggestions should encourage positive behavior (“Pay at least the minimum on time”, “Set up a consistent savings plan”).
7. Identity Verification Flow: Create IdentityVerificationView. Describe how identity verification can boost the Trust Score (e.g. verifying your identity increases reliability). Include step indicators (1. Submit ID, 2. Take a selfie, 3. Confirm personal details). Use placeholders or images to represent the steps. The final step should confirm that the feature is coming soon and no data is collected yet.
8. Animations and Haptics: When the Trust Score updates (simulated on view appear or refresh), animate the gauge smoothly from the old value to the new one. Provide haptic feedback when the user expands a metric or completes a step in the verification flow.
9. Accessibility: Ensure that the score, charts and tips are accessible. Use descriptive labels (“Your Trust Score is 740, which is considered very good. It has increased by 12 points since last month.”). Charts should include alternative descriptions or allow users to tap data points and read values aloud. Use sufficient color contrast and provide high-contrast alternatives when required.
10. Previews and Tests: Add previews for the Trust overview, score card, metric rows and detail views. Display sample data in light/dark modes and large dynamic type sizes. Write unit tests for TrustOverviewViewModel verifying correct aggregation of weighted metrics into the overall score. Add snapshot tests for UI components to detect layout regressions.

⸻

Design Requirements

• Encouraging and Transparent: The Trust section must make users feel empowered to improve. Use supportive language (“You’re on track!”) rather than punitive (“Poor Score”). Clearly explain each metric in plain language.

• Readable and Organized: Present metrics in a clear hierarchy. Use spacing, typography and color to differentiate sections. Avoid cramming too much text; use collapsible sections or secondary pages for detailed explanations.

• Color Coding: Use the Design System’s success, warning and error colors to indicate healthy, average and needs-improvement metrics. Ensure colors meet accessibility contrast ratios. Provide descriptive labels so users with color blindness understand state.

• Consistent Components: Reuse card patterns, buttons and charts from the Design System. Do not invent new UI patterns unless necessary.

• Progressive Disclosure: Surface high-level information on the overview, with deeper details available on tap. This prevents overwhelming the user.

⸻

Performance

• Use lightweight views for metric rows and charts. Do not recalculate scores on every re-render; compute in the view model.

• If using charts, limit data points for the mock history to avoid rendering hundreds of points. A dozen monthly points suffice.

• Only animate values that change. Avoid animating entire screens unnecessarily.

⸻

Accessibility

• Announce score and changes clearly. E.g. “Trust Score, 740, up twelve points since last month.”

• Provide descriptions for charts via accessibilityChartDescriptor when using Charts framework (iOS 17+).

• Ensure that metric names and tips are readable and use plain language. Offer support for VoiceOver, Voice Control and Switch Control.

• Respect user settings for Dynamic Type and Bold Text. If necessary, break lines differently for larger text.

⸻

Testing

• Unit Tests: Verify that TrustOverviewViewModel calculates the overall score by summing weighted metric values. Test that the mock service produces expected sample data.

• Snapshot Tests: Capture the Trust overview and detail screens in light and dark modes. Assert that gauges, charts and lists appear as intended.

• UI Tests: Simulate tapping metrics, navigating to detail views, and triggering identity verification. Ensure no crashes or unexpected behavior occur. Verify that accessibility labels are present.

⸻

Documentation

Create a new file /docs/architecture/Trust.md:

• Describe how the Trust Score and metrics are computed (e.g. simple weighted average) and how weights were chosen for demonstration purposes.

• Explain each metric and its meaning in the context of building financial trust. Provide examples of activities that could influence each metric.

• Document the mock data generation and how to replace it with real data in later phases (e.g. connecting to payroll providers for income stability, linking bank accounts for savings habits).

• Note any ethical considerations regarding alternative credit scoring and emphasize that this implementation is for educational purposes only.

Add entries to DECISIONS.md explaining important choices (e.g. selection of metrics, weighting method, avoiding FICO language) and decisions about UI (e.g. radial gauge vs. bar chart).

⸻

Completion

When this phase is complete:

• Test the Trust section across devices, modes and accessibility settings. Ensure that the section feels encouraging and educational. Confirm that no real personal data is processed or stored.

• Summarize what was built, including models, services, views and view models. Note any areas that need refinement or features deferred to later phases (e.g. real data ingestion, advanced analytics, regulatory compliance).

• Update DECISIONS.md with the major architectural and UX decisions made.

After summarizing and documenting, do not begin Phase 08. Wait for review and approval.

⸻

Do not begin the next phase, even if you believe there is remaining context. Your job is to complete only this phase, verify it builds cleanly, update DECISIONS.md with any architectural decisions, summarize the work performed, and wait for further instructions.
