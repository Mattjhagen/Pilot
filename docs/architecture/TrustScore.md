Trust Score Architecture

The Trust Score is a behavioural creditworthiness indicator for Pilot.  Unlike traditional FICO scores, which primarily reflect a person’s history of borrowing and repaying on credit products, Pilot’s Trust Score leverages a broader set of financial signals to provide a more holistic, real‑time view of a user’s financial health.  Its purposes are to:

* Provide users with a clear measure of financial stability and responsibility.
* Inform Pilot’s AI engine when making recommendations (e.g. cash‑flow alerts, investment suggestions, lending limits).
* Serve as an internal underwriting input when offering lending products, without being the sole determinant.
* Encourage positive financial behaviours by explaining the factors that improve the score and offering actionable guidance.

Data Categories

The Trust Score uses multiple categories of alternative financial data, inspired by research on alternative credit scoring.  Traditional credit scores do not consider income or spending habits , so adding additional signals can expand access to credit and more accurately assess risk .  Pilot sources and aggregates these signals with the user’s permission:

Income & Employment Stability

* Verified income: Regular pay from an employer, including salary and wages.  Varying income streams (gig work, seasonal jobs, freelance contracts) are also considered .
* Employment history: Length of current employment, frequency of job changes, and verified records from payroll providers (e.g. The Work Number) .
* Income consistency: Regularity and predictability of income deposits; a stable pay schedule contributes positively .

Spending & Cash Flow

* Recurring expenses & debt obligations: Analysis of transaction data to identify recurring bills, subscriptions and debt payments .
* Financial strain signals: Overdrafts, late payments, returned transactions or frequent reliance on payday advances .
* Expense‑to‑income ratio: Comparison of monthly expenses to net income to assess cash‑flow adequacy.

Savings & Liquidity

* Emergency fund: Balance of liquid savings relative to typical monthly expenses; a larger buffer signals resilience and financial discipline .
* Savings habits: Regular transfers into savings accounts, rounding up transactions, and participation in long‑term savings plans (e.g. retirement contributions).
* Liquidity ratio: Cash on hand and readily accessible assets relative to outstanding short‑term liabilities.

Debt & Credit Utilisation

* Credit utilisation: Ratio of revolving credit balances to available limits; lower utilisation shows prudent credit management.
* Debt‑service coverage: Measures how well income covers debt obligations .
* Debt trend: Change in total debt over time, emphasising reduction or responsible borrowing.

Bill Payment & Subscription Management

* On‑time bill payments: Consistent payment of obligations that rarely appear on credit reports—such as rent, utilities and telecommunications .
* Subscription health: Avoidance of frequent overdrafts due to subscription charges; timely cancellation of unused subscriptions.

Financial Goals & Behaviour

* Goal completion: Progress toward user‑defined financial goals (e.g. saving for a vacation, paying down a loan).
* Financial resilience behaviours: Actions like buying insurance, maintaining emergency funds, or diversifying investments.
* Engagement with Pilot: Use of budgeting tools, automations and educational resources.

Identity & Verification

* Identity proofing: Completion of Know‑Your‑Customer (KYC) requirements and verification of government identification.
* Fraud risk signals: Absence of red flags in identity documents or account behaviours (e.g. mismatched addresses, high‑risk geolocations).

Data Sources & Ingestion

Pilot collects data from multiple sources only with explicit user permission:

* Open Banking APIs: Access to bank transaction data (income deposits, spending patterns, savings transfers).  Users link accounts through regulated providers, and data is pulled securely via OAuth‐style flows .
* Payroll providers: Verified income and employment data from services such as The Work Number or payroll APIs .
* Bill payment networks: Records of rent, utilities and subscription payments to capture on‑time payment history .
* Manual input: Users can self‑report income, employment or financial goals; these inputs are verified when possible.
* Credit bureaus (optional): Traditional credit scores and credit reports may be incorporated for context, but the Trust Score emphasises alternative data.

The ingestion pipeline performs the following steps:

1. Consent & permissioning: Present clear consent dialogs explaining what data will be collected and how it will be used.  Users decide which accounts to connect .
2. Secure transport & storage: Use TLS 1.2+ and certificate pinning (see Security.md) for all data transfers.  Store tokens in the Keychain and encrypt at rest.
3. Data normalisation & parsing: Map diverse data formats into a unified schema.  Remove duplicates, correct errors, and categorise transactions.
4. Feature extraction: Compute metrics (e.g. income frequency, monthly spending, savings rate) needed for the score.
5. Anonymisation & aggregation: Store only aggregated metrics wherever possible.  Raw data is retained securely and only for as long as necessary.

Scoring Algorithm

The Trust Score is a weighted composite of the metrics above, scaled from 0 to 100.  A higher score indicates stronger financial stability and reliability.  The algorithm is designed to be transparent, explainable and fair:

* Weighting & calibration: Each category contributes a portion of the score.  Income stability and savings habits may carry more weight than discretionary spending.  Calibration occurs regularly to reflect evolving economic conditions and user behaviour.
* Frequent updates: The score is recalculated whenever new data is ingested (typically daily) to provide a near‑real‑time view, unlike traditional scores that update monthly .
* Explainability: Alongside the numerical score, the system produces a narrative and a breakdown of contributors—e.g. “On‑time utility payments (+2)”, “High credit utilisation (–3)”, “Stable income (+5)”.  Users see which actions improve the score and receive personalised suggestions.
* Machine learning models: Over time, Pilot may employ ML models to weight features or predict default risk.  Models will be trained on anonymised, consented data and validated for bias and fairness.  Results must remain interpretable; black‑box models are avoided for core scoring.

Fairness, Transparency & Privacy

Fairness and inclusion are central to the Trust Score.  Traditional credit scoring models can inadvertently disadvantage women and other groups , so Pilot’s design strives to mitigate bias and support equitable access to financial services:

* Exclude sensitive attributes: The score must not directly use race, gender, religion, nationality, marital status or age.  Proxy variables that correlate strongly with these attributes should also be avoided.  Instead, rely on behavioural and financial signals.
* Legal and ethical compliance: Follow regulations in all relevant jurisdictions.  The AFI report notes that a clear legal and ethical framework is required to govern credit reporting and protect consumer rights .
* Relevant, accurate data: Collect positive and negative data from reliable sources.  The General Principles for Credit Reporting emphasise that data should be relevant, accurate, timely and sufficient .
* Data minimisation & protection: Only collect data necessary for the Trust Score, and retain it for a limited time.  Implement rigorous security and privacy controls (see Security.md).
* User control & consent: Users decide what data to share and can revoke access at any time.  Provide clear explanations of how their data influences the score and how to dispute errors.
* Fairness testing: Regularly evaluate the scoring algorithm for disparate impact across demographic groups using fairness metrics.  Adjust weights or factors when bias is detected.
* Auditability: Maintain versioned models and record the reasoning behind changes in DECISIONS.md.  Provide regulators and auditors with documentation of data sources, model performance and fairness tests.

Updating & Event Triggers

Trust Scores should update when meaningful changes occur:

* New data: When new bank transactions, payroll updates or payment records arrive, recompute the score.
* Life events: Users can inform the system of major changes (e.g. job loss, pay raise, new child).  Such events may adjust income stability or required emergency fund thresholds.
* Goal completion: When a user achieves a savings goal or pays off a loan, update their score and offer new goals.
* Credit events: If a user opens a new credit line or closes an account, incorporate the change into utilisation and debt trend metrics.

Integration with AI Copilot & Lending

Pilot’s AI Copilot uses the Trust Score to tailor recommendations:

* Personalised advice: Suggest actions to improve the score (e.g. “Increase emergency savings by $500”, “Pay down credit card to lower utilisation”).
* Risk‑aware automation: Adjust automations based on score (e.g. only invest extra cash when the Trust Score exceeds a threshold; hold more cash when it drops).
* Lending offers: Use the Trust Score as one of several inputs for loan decisions and interest rates.  Lending decisions also consider affordability, risk tolerances, compliance and the user’s own preferences.

Data Storage & Security

* Secure storage: Store aggregated metrics in local encrypted databases and sensitive tokens in the Keychain, following the guidelines in Security.md.  Raw transaction data should be encrypted and access‑controlled.
* Access control: Only authorised components (Trust Engine services) may access the raw data.  UI components use aggregated and anonymised data.
* Regulatory compliance: Comply with data protection laws (e.g. GDPR, CCPA).  Provide mechanisms for data access requests and deletion.

Testing & Governance

To maintain confidence and quality, Pilot will:

* Unit & integration tests: Validate metric calculations, weighting logic and edge cases (e.g. irregular income).  Test the scoring algorithm across different data scenarios.
* Data simulation: Use synthetic datasets to test fairness and performance without exposing real user data.
* Human review loops: Periodically review automatically generated scores and narratives to ensure they align with human judgement and regulatory guidelines.
* Model governance: Document decisions, rationale, and versions in DECISIONS.md.  Establish a review process whenever weights or models change.  Coordinate with legal and compliance teams for approvals.

Extensibility & Future Considerations

Pilot’s Trust Score should evolve with user needs and regulatory landscapes:

* Additional data sources: Incorporate verified rental records, education history, or small‑business cash flow data as open banking and data portability expand .
* Global adaptations: Adjust metrics and weightings for different regions to reflect cultural and economic differences; ensure compliance with local regulations.
* User feedback: Allow users to provide context when scores drop and incorporate appeals into the scoring process.
* Continuous research: Monitor emerging studies and regulatory guidance on alternative data and ethical AI to refine metrics and algorithms.

By combining transparency, behavioural data and rigorous governance, Pilot’s Trust Score aims to create a fairer and more comprehensive measure of financial trust.  It empowers users with actionable insights and helps Pilot deliver responsible financial services while avoiding the pitfalls of traditional credit scoring.
