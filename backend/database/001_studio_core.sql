-- Run only in your newly created Supabase project's SQL editor after reviewing.
-- This migration does NOT create an admin automatically and does NOT expose a service role.
create extension if not exists pgcrypto;

create table if not exists public.admin_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.admin_members enable row level security;
revoke all on public.admin_members from anon;
grant select on public.admin_members to authenticated;
create policy "member may read own membership" on public.admin_members
  for select to authenticated using (user_id = (select auth.uid()));

create or replace function public.is_portfolio_admin()
returns boolean language sql stable security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.admin_members
    where user_id = (select auth.uid())
  );
$$;
revoke all on function public.is_portfolio_admin() from public;
grant execute on function public.is_portfolio_admin() to authenticated;

create table if not exists public.portfolio_projects (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
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
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  title text not null,
  excerpt text not null default '',
  category text,
  cover_asset_path text,
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
  check (
    (owner_kind='project' and project_id is not null and post_id is null)
    or (owner_kind='post' and post_id is not null and project_id is null)
  )
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

alter table public.portfolio_projects enable row level security;
alter table public.portfolio_posts enable row level security;
alter table public.portfolio_blocks enable row level security;
alter table public.portfolio_media enable row level security;

grant select on public.portfolio_projects, public.portfolio_posts, public.portfolio_blocks, public.portfolio_media to anon;
grant select, insert, update, delete on public.portfolio_projects, public.portfolio_posts, public.portfolio_blocks, public.portfolio_media to authenticated;

create policy "view published projects" on public.portfolio_projects
  for select to anon, authenticated using (status = 'published');
create policy "admins read all projects" on public.portfolio_projects
  for select to authenticated using (public.is_portfolio_admin());
create policy "admins insert projects" on public.portfolio_projects
  for insert to authenticated with check (public.is_portfolio_admin());
create policy "admins update projects" on public.portfolio_projects
  for update to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "admins delete projects" on public.portfolio_projects
  for delete to authenticated using (public.is_portfolio_admin());

create policy "view published posts" on public.portfolio_posts
  for select to anon, authenticated using (status = 'published');
create policy "admins read all posts" on public.portfolio_posts
  for select to authenticated using (public.is_portfolio_admin());
create policy "admins insert posts" on public.portfolio_posts
  for insert to authenticated with check (public.is_portfolio_admin());
create policy "admins update posts" on public.portfolio_posts
  for update to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "admins delete posts" on public.portfolio_posts
  for delete to authenticated using (public.is_portfolio_admin());

create policy "read blocks for published content" on public.portfolio_blocks
  for select to anon, authenticated using (
    exists(select 1 from public.portfolio_projects p where p.id = project_id and p.status = 'published')
    or exists(select 1 from public.portfolio_posts p where p.id = post_id and p.status = 'published')
  );
create policy "admins read all blocks" on public.portfolio_blocks
  for select to authenticated using (public.is_portfolio_admin());
create policy "admins insert blocks" on public.portfolio_blocks
  for insert to authenticated with check (public.is_portfolio_admin());
create policy "admins update blocks" on public.portfolio_blocks
  for update to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "admins delete blocks" on public.portfolio_blocks
  for delete to authenticated using (public.is_portfolio_admin());

create policy "view public media metadata" on public.portfolio_media
  for select to anon, authenticated using (approved_for_public);
create policy "admins read all media metadata" on public.portfolio_media
  for select to authenticated using (public.is_portfolio_admin());
create policy "admins insert media metadata" on public.portfolio_media
  for insert to authenticated with check (public.is_portfolio_admin());
create policy "admins update media metadata" on public.portfolio_media
  for update to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "admins delete media metadata" on public.portfolio_media
  for delete to authenticated using (public.is_portfolio_admin());

-- Do not create an open insert policy for admin_members.
-- Insert your own user_id through the trusted SQL editor after signing up and enabling MFA.
-- Bucket policies, API validation, sanitisation and revisions are separate milestones.
