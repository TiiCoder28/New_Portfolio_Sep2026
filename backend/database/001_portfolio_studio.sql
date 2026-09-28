-- Portfolio Studio draft schema (not auto-applied). Review before running in your Supabase SQL editor.
-- Authenticated access is explicitly gated through the admin_members table.
create extension if not exists pgcrypto;

create table if not exists public.admin_members (
 user_id uuid primary key references auth.users(id) on delete cascade,
 created_at timestamptz not null default now()
);

create or replace function public.is_portfolio_admin()
returns boolean language sql stable security definer set search_path = ''
as $$ select exists (select 1 from public.admin_members where user_id = (select auth.uid())); $$;

revoke all on function public.is_portfolio_admin() from public;
grant execute on function public.is_portfolio_admin() to authenticated, anon;

create table if not exists public.portfolio_projects (
 id uuid primary key default gen_random_uuid(),
 slug text not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
 title text not null,
 summary text not null default '',
 category text not null default '',
 hero_asset_path text,
 github_url text,
 live_url text,
 featured boolean not null default false,
 sort_order integer not null default 0,
 status text not null default 'draft' check (status in ('draft','published','archived')),
 published_at timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);

create table if not exists public.portfolio_posts (
 id uuid primary key default gen_random_uuid(),
 slug text not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
 title text not null,
 excerpt text not null default '',
 cover_asset_path text,
 category text,
 status text not null default 'draft' check (status in ('draft','published','archived')),
 published_at timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);

create table if not exists public.portfolio_blocks (
 id uuid primary key default gen_random_uuid(),
 owner_kind text not null check (owner_kind in ('project','post')),
 project_id uuid references public.portfolio_projects(id) on delete cascade,
 post_id uuid references public.portfolio_posts(id) on delete cascade,
 block_type text not null check (block_type in ('heading','rich_text','image','gallery','quote','code','split_media_text','architecture_diagram')),
 body jsonb not null default '{}'::jsonb,
 sort_order integer not null default 0,
 check ((owner_kind='project' and project_id is not null and post_id is null) or (owner_kind='post' and post_id is not null and project_id is null))
);

create table if not exists public.portfolio_media (
 id uuid primary key default gen_random_uuid(),
 storage_path text not null unique,
 alt_text text not null default '',
 mime_type text not null,
 size_bytes bigint not null check (size_bytes > 0 and size_bytes <= 10000000),
 approved_for_public boolean not null default false,
 created_at timestamptz not null default now()
);

create table if not exists public.portfolio_site_settings (
 setting_key text primary key,
 draft_value jsonb not null default '{}'::jsonb,
 published_value jsonb not null default '{}'::jsonb,
 updated_at timestamptz not null default now()
);

alter table public.admin_members enable row level security;
alter table public.portfolio_projects enable row level security;
alter table public.portfolio_posts enable row level security;
alter table public.portfolio_blocks enable row level security;
alter table public.portfolio_media enable row level security;
alter table public.portfolio_site_settings enable row level security;

create policy "admin can read own membership" on public.admin_members for select to authenticated using (user_id = (select auth.uid()));
create policy "public published projects" on public.portfolio_projects for select to anon, authenticated using (status='published');
create policy "admins manage projects" on public.portfolio_projects for all to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "public published posts" on public.portfolio_posts for select to anon, authenticated using (status='published');
create policy "admins manage posts" on public.portfolio_posts for all to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "public published project or post blocks" on public.portfolio_blocks for select to anon, authenticated using (
 exists(select 1 from public.portfolio_projects p where p.id = project_id and p.status='published') or
 exists(select 1 from public.portfolio_posts a where a.id = post_id and a.status='published')
);
create policy "admins manage blocks" on public.portfolio_blocks for all to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "public approved media metadata" on public.portfolio_media for select to anon, authenticated using (approved_for_public);
create policy "admins manage media metadata" on public.portfolio_media for all to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "public settings" on public.portfolio_site_settings for select to anon, authenticated using (true);
create policy "admins manage settings" on public.portfolio_site_settings for all to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());

-- Never create an open insert policy on admin_members. Provision your own auth user id
-- using a trusted SQL editor with elevated access; never accept a user-supplied role claim.
-- Storage bucket policies, API auth/MFA, rich-text sanitisation, validation and revision
-- history must be implemented before enabling Studio writes.
