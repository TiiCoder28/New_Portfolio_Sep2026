# Portfolio Studio: implementation contract

- Public site (Vue + JS + Tailwind) reads only published content.
- Private Studio (separate Vue app within monorepo) manages drafts, revisions, block layouts, media and site settings.
- FastAPI verifies every privileged request; the route name or subdomain is **not** a security boundary.
- Supabase Auth + MFA; server checks trusted admin identity and applies database authorization / RLS. No client-supplied role is authoritative.
- Editor blocks are typed and validated: heading, rich_text, image, gallery, split_media_text, quote, code, architecture_diagram. No arbitrary HTML/script execution.
- Project records: slug, title, summary, hero asset, Github/live links if verified, visibility, featured, sort order and publication state.
- Posts: slug, title, excerpt, cover asset, categories, draft/published status, publication timestamp and ordered typed blocks.
- Media: approved screenshots and portrait, MIME/size validation, alt text, attribution and rights confirmation; confidential client imagery is opt-in only.
- Layout/settings: constrained component variants, colours and typography tokens, per-section visibility/order, draft preview and revision rollback.
- Analytics: distinguish views and approximate unique visitors; privacy-aware collection, retention and disclosure.
- Chatbot: answers grounded in published approved content, backed by server-side rate limits, API key isolation and retrieval source checking.

Milestone sequence: (1) auth/data access schema and tests, (2) studio CRUD + media, (3) publication pipeline and public dynamic data, (4) analytics, (5) chatbot.
