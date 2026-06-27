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

    const { email, source = 'landing_page' } = await req.json()

    // Validate email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!email || !emailRegex.test(email)) {
      return new Response(JSON.stringify({ error: 'Invalid email address' }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      })
    }

    const supabase = createClient(supabaseUrl, supabaseKey)

    // Insert into waitlist
    const { error: insertError } = await supabase
      .from('waitlist')
      .insert([{ email, source }])

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
        subject: 'Welcome to the Pilot Early Access List',
        html: `
          <div style="font-family: sans-serif; color: #111;">
            <h2>You're on the list.</h2>
            <p>Thanks for requesting early access to Pilot.</p>
            <p>We are currently operating in a closed prototype phase, but we'll reach out as soon as a spot opens up for you.</p>
            <p>Best,<br/>The Pilot Team</p>
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
