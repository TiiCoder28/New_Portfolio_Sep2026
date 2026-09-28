import { createClient } from '@supabase/supabase-js'

const url = import.meta.env.VITE_SUPABASE_URL
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY
export const configured = Boolean(url && key && import.meta.env.VITE_API_URL)
export const supabase = configured ? createClient(url, key) : null

export async function studioRequest(path, options = {}) {
  if (!configured) throw new Error('Configure the Studio .env file first.')
  const { data: { session }, error } = await supabase.auth.getSession()
  if (error || !session?.access_token) throw new Error('Sign in first.')
  const response = await fetch(import.meta.env.VITE_API_URL.replace(/\/$/, '') + '/api/studio/' + path, {
    ...options,
    headers: {
      'Authorization': 'Bearer ' + session.access_token,
      'Content-Type': 'application/json',
      ...(options.headers || {})
    }
  })
  const payload = await response.json().catch(() => ({}))
  if (!response.ok) throw new Error(payload.detail || 'Studio request failed.')
  return payload
}
