# Portfolio Studio database setup

The migration `001_studio_core.sql` is designed for a **new Supabase project** and has not been executed by ChatGPT. Review and run it in Supabase SQL Editor only after creating the project.

1. Create Supabase project (use the same region as your planned backend where practical).
2. Under Project Settings → API (or API Keys), retrieve the project URL and its **publishable/legacy anon key**; never use a service-role/secret key in the browser.
3. Copy `backend/.env.example` to `backend/.env`, fill in project URL and publishable/anon key.
4. Run `001_studio_core.sql` in a fresh project. Review RLS policies in the Dashboard.
5. Create your own Auth user and enroll a TOTP second factor; confirm your session has AAL2.
6. In the Supabase SQL Editor, provision **only your own actual Auth user UUID** with:
   `insert into public.admin_members (user_id) values ('YOUR_AUTH_USER_UUID');`
   The table has no client-side insert/update policy.
7. For local API: install backend requirements and run `uvicorn app.main:app --reload` from `backend/`. `GET /health` should report database_configured true.
8. Use the signed-in session access token as a Bearer token for Studio endpoints, after MFA verification.
9. Public `GET /api/projects` and `GET /api/posts` return only published rows. Studio endpoints require Supabase-authenticated **AAL2** and the admin membership row.

**Not implemented yet:** browser login UI, TOTP enrollment/verification screens, project/post editor UI, typed block APIs, Storage upload policies, revisions, analytics and chatbot. Do not enable public media uploads or expose admin writes in production before security and integration testing.

Never paste your passwords, JWTs, private API credentials or TOTP recovery codes into a chat or GitHub repository.
