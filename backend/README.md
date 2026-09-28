# Backend foundation

Initial FastAPI service: GET /health only. No unauthenticated content mutations or fake admin API are exposed.

From the backend directory:

```bash
python -m venv .venv
# Activate your environment, then:
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Next: Supabase schema, verified Supabase JWT validation (issuer, audience, signature, expiry), server-side admin allowlist, restricted storage, authorisation tests, and draft/preview/publish endpoints. Use separate service credentials in server-only environment variables, never in Vue.
