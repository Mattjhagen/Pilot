# Pilot Landing Page (pilotfinance.space)

This directory (`/docs`) contains the static landing page for Pilot, accessible at [pilotfinance.space](https://pilotfinance.space).

## Structure
- `index.html`: The main landing page markup.
- `style.css`: The styling, relying on standard CSS to remain lightweight and easy to maintain without external frameworks.

## Design & Features
The landing page adheres strictly to the Pilot Design Language (PDL), utilizing:
- Deep charcoal backgrounds
- Soft glass cards (`var(--glass-bg)`)
- Subtle gradients for hero elements like the Financial Health orb
- Inter font for crisp, modern typography

### Accessibility
- **Reduced Motion**: Full support for `prefers-reduced-motion` to automatically disable CSS animations (breathing orbs, floating cards, scroll reveals) for users who prefer static layouts.

### Social & Meta
- **OpenGraph & Twitter**: Fully configured meta tags for social sharing.
- **Favicon**: Minimalist Pilot orb SVG favicon.
- **Placeholder OG Image**: Located at `assets/og-image.svg`.

### Call To Action (CTA)
- The "Join Early Access" CTA is currently wired to a `mailto:` link (`earlyaccess@pilotfinance.space`) while the product is in prototype review.
- The "Watch Demo" button triggers an alert indicating it is coming soon.

### Interactive Pilot Simulator
- **Location:** Added after the "Meet your AI CFO" narrative section.
- **Dual-Mode Experience:** 
  - **Guided Tour:** Runs a cinematic 36-second JS storyboard simulating the AI CFO in action (Morning Briefing -> Insight -> Automation -> Trust Boost -> Lending -> Daily Brief -> Final Cinematic).
  - **Explore Yourself:** A lightweight Vanilla JS state-machine embedded in the page that lets users tap through the 5 app tabs, execute an automation, watch their Trust Score and balance dynamically update, and complete a mocked lending flow.
- **Tech:** Uses pure HTML/CSS representations. Managed by custom JavaScript in `index.html`. 
  - The Interactive Mode uses a global `appState` object and a reactive `renderSim()` function to update the DOM on state changes.
- **Responsive Layout:** To prevent complex touch-target overlap and forced scrolling within the CSS phone frame on mobile devices, the "Interactive" toggle is hidden on screens under `768px`, meaning mobile users will automatically only see the Guided Tour.
- **Reduced Motion:** If `prefers-reduced-motion` is enabled, the Guided Tour halts before starting, keeping the user securely on the static initial dashboard frame without sudden animations.

## What Needs to be Replaced Before Public Launch
- Replace the `mailto:` CTA with an actual waitlist/backend integration (e.g., Mailchimp, custom API).
- Replace the placeholder "Watch Demo" alert with a real video modal or external link.
- Consider replacing the SVG OpenGraph image (`assets/og-image.svg`) with a high-fidelity PNG/JPG if social platforms struggle with SVG parsing for link previews.
- Remove the "Prototype Disclaimer" at the bottom of the page once real financial rails are connected.

## GitHub Pages Configuration
To serve this site on GitHub Pages:
1. Go to the repository **Settings** on GitHub.
2. Navigate to the **Pages** section on the left sidebar.
3. Under **Build and deployment**, set the **Source** to `Deploy from a branch`.
4. Under **Branch**, select `main` (or your primary branch) and set the folder to `/docs`.
5. Click **Save**.

## DNS Configuration for pilotfinance.space
To use the custom domain `pilotfinance.space`:
1. In the repository **Settings > Pages** section, enter `pilotfinance.space` in the **Custom domain** field and save.
2. This will automatically generate a `CNAME` file in the repository root or `/docs` folder.
3. In your DNS provider (e.g., Cloudflare, Namecheap, Route53), add the following records:
   - **A Records** pointing to GitHub's IP addresses:
     - `185.199.108.153`
     - `185.199.109.153`
     - `185.199.110.153`
     - `185.199.111.153`
   - **CNAME Record** for `www.pilotfinance.space` pointing to `<your-github-username>.github.io`.
4. Wait for DNS to propagate (can take a few minutes to a few hours).
5. Back in GitHub Pages settings, ensure **Enforce HTTPS** is checked once the certificate is provisioned.
