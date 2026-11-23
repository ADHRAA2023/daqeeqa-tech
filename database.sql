-- Run in Supabase SQL Editor. Create the first admin user in Authentication > Users.
create table if not exists public.programs (
 id text primary key,
 name text not null,
 category text not null,
 description text not null default '',
 steps text not null default '',
 classroom_use text not null default '',
 url text not null default '',
 video_url text not null default ''
);
create table if not exists public.admins (user_id uuid primary key references auth.users(id) on delete cascade);
alter table public.programs enable row level security;
alter table public.admins enable row level security;
create policy "Public can view programs" on public.programs for select to anon, authenticated using (true);
create policy "Admins can insert" on public.programs for insert to authenticated with check (exists(select 1 from public.admins where user_id=auth.uid()));
create policy "Admins can update" on public.programs for update to authenticated using (exists(select 1 from public.admins where user_id=auth.uid())) with check (exists(select 1 from public.admins where user_id=auth.uid()));
create policy "Admins can delete" on public.programs for delete to authenticated using (exists(select 1 from public.admins where user_id=auth.uid()));
create policy "Admins can see own admin membership" on public.admins for select to authenticated using (user_id=auth.uid());
-- After creating your admin user, replace the UUID below with their Auth user ID and run:
-- insert into public.admins(user_id) values ('YOUR-ADMIN-USER-UUID');
