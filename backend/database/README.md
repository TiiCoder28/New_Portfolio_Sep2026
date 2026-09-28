# Portfolio Studio database foundation

`001_portfolio_studio.sql` is a **reviewable migration**, not yet deployed. It defines projects, posts, typed blocks, media metadata, site settings and a restricted administrator membership table, with RLS for published public content and admin mutations.

Before executing: configure Supabase project and Auth, enable MFA for the owner, check policies in an isolated environment, provision exactly the intended admin user via trusted elevated SQL, configure Storage policies and plan versioned backups. Do not expose a service-role key to the Vue frontend. The schema alone is not a functional or secure CMS; the API must verify authentication and admin membership on every write.
