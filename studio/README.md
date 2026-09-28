# Portfolio Studio (private administration UI)

Separate Vue 3 + JavaScript + Tailwind frontend. **Not deployed automatically.** A non-obvious URL is not a security boundary: the backend validates Supabase Auth, MFA (AAL2), administrator membership and database RLS.

```powershell
cd studio
npm install
Copy-Item .env.example .env
# Set VITE_SUPABASE_URL, VITE_SUPABASE_PUBLISHABLE_KEY and VITE_API_URL.
npm run dev
```

Create your Auth user in your Supabase Dashboard and enable TOTP MFA. Enrol or challenge your factor in the Studio UI. The backend must have its own `backend/.env` and the reviewed migration must be applied before the Studio will authorise access.

First milestone: email/password sign-in, TOTP MFA, admin session verification, project/post metadata list, create, edit, publish and archive.

**Not yet supported:** upload gallery assets, content block editing, responsive homepage customisation, revision history, analytics. The Studio does not create administrator accounts or grant itself privileges.
