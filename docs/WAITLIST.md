# Waitlist Integration Guide

Pilot uses a robust, serverless waitlist infrastructure powered by **Supabase Edge Functions** and **Resend**. This ensures that all API keys and secrets remain securely on the backend, while our static GitHub Pages landing page remains purely frontend.

## 1. Database Schema (Supabase)

You must create a `waitlist` table in your Supabase project.

Run the following SQL in the Supabase SQL Editor:

```sql
create table if not exists waitlist (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  source text default 'landing_page',
  status text default 'waiting',
  referral_code text unique,
  referred_by text,
  user_agent text,
  created_at timestamptz default now()
);
```

## 2. Environment Secrets

The Supabase Edge Function requires the following secrets to be set in your Supabase project.

**Required Secrets:**
* `SUPABASE_URL`: Your Supabase project URL (e.g., `https://your-project.supabase.co`)
* `SUPABASE_SERVICE_ROLE_KEY`: The Service Role JWT from Supabase (required to bypass RLS for inserts).
* `RESEND_API_KEY`: Your Resend API Key (`re_xxxxxxxxxxxxx`).
* `FROM_EMAIL`: The verified sender address in Resend (e.g., `Pilot <earlyaccess@pilotfinance.space>`).

To set these secrets in Supabase via the CLI:
```bash
supabase secrets set SUPABASE_URL=https://YOUR_PROJECT.supabase.co
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=YOUR_SERVICE_ROLE_KEY
supabase secrets set RESEND_API_KEY=re_xxxxxxxxxxxxx
supabase secrets set FROM_EMAIL="Pilot <earlyaccess@pilotfinance.space>"
```

## 3. Edge Function Deployment

The Edge Function source code is located at `supabase/functions/waitlist-signup/index.ts`.

To deploy the function to your Supabase project:
```bash
supabase functions deploy waitlist-signup --no-verify-jwt
```
*(Note: `--no-verify-jwt` is used because this is a public endpoint invoked by unauthenticated users on the landing page.)*

## 4. Frontend Configuration

In `docs/index.html`, locate the `PILOT_CONFIG` object at the bottom of the script block.

**You MUST replace the placeholder with your actual Supabase Edge Function URL before launching:**
1. Find `PILOT_CONFIG.waitlistEndpoint`
2. Replace `YOUR_SUPABASE_PROJECT_REF` with the actual Supabase project ref
3. Example format:
    `https://abc123xyz.functions.supabase.co/waitlist-signup`

```javascript
const PILOT_CONFIG = {
  waitlistEndpoint: "https://YOUR_SUPABASE_PROJECT_REF.functions.supabase.co/waitlist-signup"
};
```

## 5. Manual Testing Steps

Once deployed and configured:
1. Open `https://pilotfinance.space` (or serve `docs/index.html` locally).
2. Scroll to the waitlist section.
3. Enter a valid email address and click "Reserve Spot".
4. **Verify UI:** The button should read "Joining...", disable itself, and then output "You’re on the list. Welcome aboard."
5. **Verify Supabase:** Check the `waitlist` table to ensure the new email row was created.
6. **Verify Resend:** Check your inbox to ensure the welcome email was delivered.
7. **Test Duplicates:** Submit the exact same email address again. The UI should gracefully handle it and state "You’re already on the early access list."
