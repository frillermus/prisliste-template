-- Optional Supabase setup. This SQL is NOT needed for browser-only/local mode.
-- Run it in the Supabase SQL editor only if you choose to enable shared accounts and data.
-- Create employee accounts in Supabase Authentication, then assign the first admin role below.

create table if not exists public.user_roles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('admin', 'employee')) default 'employee'
);

create table if not exists public.app_settings (
  id boolean primary key default true check (id),
  config jsonb not null,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id) on delete set null
);

insert into public.app_settings (id, config) values (
  true,
  '{"businessName":"Min virksomhed","tagline":"Prisliste","currency":"kr","customerLabel":"Kunde","referenceLabel":"Reference / nummer","receiptLabel":"Overslag","preset":"general","categories":[{"name":"Ydelser","items":[{"name":"Eksempel på ydelse","price":100}]},{"name":"Produkter","items":[{"name":"Eksempel på produkt","price":50}]}]}'::jsonb
) on conflict (id) do nothing;

create table if not exists public.receipts (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null,
  created_by_name text not null default '',
  kind text not null check (kind in ('police', 'civil')),
  receipt_data jsonb not null
);

alter table public.user_roles enable row level security;
alter table public.app_settings enable row level security;
alter table public.receipts enable row level security;

grant select on public.user_roles to authenticated;
grant select, update on public.app_settings to authenticated;
grant select, insert, delete on public.receipts to authenticated;

drop policy if exists "Users can read permitted roles" on public.user_roles;
create policy "Users can read permitted roles" on public.user_roles
  for select to authenticated using (user_id = (select auth.uid()));
drop policy if exists "Signed-in users can read app settings" on public.app_settings;
create policy "Signed-in users can read app settings" on public.app_settings
  for select to authenticated using (true);
drop policy if exists "Admins can update app settings" on public.app_settings;
create policy "Admins can update app settings" on public.app_settings
  for update to authenticated
  using (exists (select 1 from public.user_roles r where r.user_id = (select auth.uid()) and r.role = 'admin'))
  with check (exists (select 1 from public.user_roles r where r.user_id = (select auth.uid()) and r.role = 'admin'));
drop policy if exists "Signed-in employees can read shared receipts" on public.receipts;
create policy "Signed-in employees can read shared receipts" on public.receipts
  for select to authenticated using (true);
drop policy if exists "Employees can add their own receipts" on public.receipts;
create policy "Employees can add their own receipts" on public.receipts
  for insert to authenticated with check (created_by = (select auth.uid()));
drop policy if exists "Employees can delete their own receipts" on public.receipts;
create policy "Employees can delete their own receipts" on public.receipts
  for delete to authenticated using (created_by = (select auth.uid()));

do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'receipts') then
    execute 'alter publication supabase_realtime add table public.receipts';
  end if;
end
$$;
