# FastAPI portfolio backend

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
# Set SUPABASE_URL and SUPABASE_ANON_KEY in your local .env file.
uvicorn app.main:app --reload
```

The API works without Supabase: `GET /health` returns `database_configured: false`. Public CMS calls return **503** until configuration is supplied.

Public endpoints: `GET /api/projects`, `GET /api/posts` (published rows only).

Studio endpoints: `GET /api/studio/session`; `GET/POST /api/studio/projects`; `PATCH/DELETE /api/studio/projects/{id}`; equivalent posts routes. DELETE currently **archives** rather than permanently deleting a record.

Security: Studio endpoints send the Bearer JWT to Supabase Auth `/auth/v1/user` to validate it, then check matching user identity, MFA assurance level `aal2`, and membership of `admin_members`. Subsequent PostgREST requests use the **user's access JWT**, preserving RLS. No service-role key is used.

Run `pytest` from `backend/`. The proposed migration `database/001_studio_core.sql` is *not yet deployed*. It should be applied only to a fresh Supabase project after review. The separate earlier case-study PR includes an alternative draft schema; **do not apply both migrations**.

Next: Studio frontend, block-based rich editing, revision history, Storage policies and full end-to-end auth testing.
