import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.4"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*', // Adjust to 'https://pilotfinance.space' for strict production
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight request
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { headers: corsHeaders, status: 405 })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const resendApiKey = Deno.env.get('RESEND_API_KEY')!
    const fromEmail = Deno.env.get('FROM_EMAIL')!

    if (!supabaseUrl || !supabaseKey || !resendApiKey || !fromEmail) {
      console.error("Missing environment variables");
      return new Response(JSON.stringify({ error: 'Server configuration error' }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      })
    }

    let { email, source = 'landing_page', companyWebsite } = await req.json()

    // Honeypot check
    if (companyWebsite && companyWebsite.trim() !== '') {
      // Silently return success for bots
      console.log('Bot detected via honeypot');
      return new Response(JSON.stringify({ message: 'success' }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      })
    }

    if (!email || typeof email !== 'string') {
      return new Response(JSON.stringify({ error: 'Missing email' }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      })
    }

    // Normalize and trim
    email = email.trim().toLowerCase()

    if (email.length > 254) {
      return new Response(JSON.stringify({ error: 'Email too long' }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      })
    }

    // Validate email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email)) {
      return new Response(JSON.stringify({ error: 'Invalid email address' }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      })
    }

    const user_agent = req.headers.get('user-agent') || 'unknown'
    const ip = req.headers.get('x-forwarded-for')
    let ip_hash = null

    if (ip) {
      const encoder = new TextEncoder()
      const data = encoder.encode(ip.split(',')[0].trim()) // take the first IP if multiple
      const hashBuffer = await crypto.subtle.digest('SHA-256', data)
      const hashArray = Array.from(new Uint8Array(hashBuffer))
      ip_hash = hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
    }

    const supabase = createClient(supabaseUrl, supabaseKey)

    // Insert into waitlist
    const { error: insertError } = await supabase
      .from('waitlist')
      .insert([{ email, source, user_agent, ip_hash }])

    if (insertError) {
      // 23505 is the PostgreSQL error code for unique violation
      if (insertError.code === '23505') {
        return new Response(JSON.stringify({ message: 'duplicate' }), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 409,
        })
      }
      console.error('Supabase Insert Error:', insertError)
      throw insertError
    }

    // Send confirmation email via Resend
    const resendRes = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${resendApiKey}`
      },
      body: JSON.stringify({
        from: fromEmail,
        to: email,
        subject: "Welcome aboard — you're on the Pilot early access list",
        html: `
          <div style="font-family: sans-serif; color: #111;">
            <h2>You're on the list.</h2>
            <p>Thanks for joining Pilot.</p>
            <p>Pilot is currently in prototype review. You'll receive updates as private testing opens.</p>
            <p>Signed,<br/>P3 Lending LLC</p>
          </div>
        `
      })
    })

    if (!resendRes.ok) {
      const resendError = await resendRes.text()
      console.error('Resend Error:', resendError)
      // Even if email fails, we successfully added to waitlist, so we log it but return success to user.
    }

    return new Response(JSON.stringify({ message: 'success' }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error) {
    console.error('Unexpected edge function error:', error)
    return new Response(JSON.stringify({ error: 'Internal server error' }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 500,
    })
  }
})
