# Pilot Trust Architecture

## Philosophy

The Trust tab establishes an alternative credit-scoring mechanism based on transparent, behavioral finance metrics rather than legacy FICO systems. It is designed to be:
- **Encouraging**: Uses supportive language and avoids punitive "red" unless a metric is truly alarming. The radial gauge provides a clear, gamified visual of progress.
- **Educational**: Focuses heavily on "Ways to Improve" via the `TrustSuggestion` model, and provides deep-dive historical context in the `TrustDetailView`.

## Components

### Data Models
Located in `TrustModels.swift`.
- `TrustScore`: The aggregated final score.
- `TrustMetric`: Individual component (e.g., "Income Stability") carrying its own weight in the final calculation. Contains an array of `TrustHistoryPoint` for charting.
- `TrustSuggestion`: Contextual tips mapped to specific metrics.

### Service Layer
`TrustService` (currently mocked via `TrustMockService`) generates the constituent metrics, varying histories using basic randomized variances, and outputs standard suggestions. This simulated delay replicates future backend processing latency.

### View Models
- `TrustOverviewViewModel`: The core orchestrator. It fetches the raw metrics and dynamically calculates the final `TrustScore` using a normalized weighted average of the `TrustMetric` components. 

### Interface
- `TrustOverviewView`: The main dashboard. Features a central `TrustScoreCard` and iterating `PilotCard`s for each metric.
- `TrustScoreCard`: Uses a custom-drawn native SwiftUI `<Circle>` gauge animated with `.trim`.
- `TrustDetailView`: Renders a native `Chart` using Swift Charts to display historical performance.
- `IdentityVerificationView`: A placeholder structural flow demonstrating how users will ultimately link their identity to boost their Trust Score.

## Note on Scoring
In this phase, the overall score is deterministically calculated purely on the client side (in `TrustOverviewViewModel`) to facilitate simple unit testing. In production, this proprietary weighting logic will exist entirely on the backend to prevent reverse engineering and client-side manipulation.
