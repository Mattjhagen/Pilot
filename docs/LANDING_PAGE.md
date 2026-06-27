# Pilot Landing Page (pilotfinance.space)

This directory (`/docs`) contains the static landing page for Pilot, accessible at [pilotfinance.space](https://pilotfinance.space).

## Structure
- `index.html`: The main landing page markup.
- `style.css`: The styling, relying on standard CSS to remain lightweight and easy to maintain without external frameworks.

## Design
The landing page adheres strictly to the Pilot Design Language (PDL), utilizing:
- Deep charcoal backgrounds
- Soft glass cards (`var(--glass-bg)`)
- Subtle gradients for hero elements like the Financial Health orb
- Inter font for crisp, modern typography

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
