-- Run this in Supabase SQL Editor. Replace OWNER_UUID after creating your owner account.
create table if not exists public.owner_users(user_id uuid primary key references auth.users(id) on delete cascade);
-- After creating/signing up your owner user, add their UUID manually:
-- insert into public.owner_users(user_id) values ('YOUR_AUTH_USER_UUID');
create table if not exists public.products(id bigint generated always as identity primary key,name text not null,price numeric(10,2) not null check(price>=0),description text,image text,active boolean default true,created_at timestamptz default now());
create table if not exists public.orders(id bigint generated always as identity primary key,customer_name text not null,email text not null,phone text not null,address text not null,items jsonb not null,total numeric(10,2) not null,status text default 'pending',created_at timestamptz default now());
create table if not exists public.visits(id bigint generated always as identity primary key,page_path text,created_at timestamptz default now());
create or replace function public.is_store_owner() returns boolean language sql security definer set search_path=public as $$ select exists(select 1 from public.owner_users where user_id=auth.uid()) $$;
create or replace function public.record_visit(page_path text) returns void language sql security definer set search_path=public as $$ insert into public.visits(page_path) values (left(page_path,300)); $$;
grant execute on function public.record_visit(text) to anon,authenticated;
grant execute on function public.is_store_owner() to authenticated;

alter table public.owner_users enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.visits enable row level security;
create policy "owner can see owner list" on public.owner_users for select to authenticated using (public.is_store_owner());
create policy "public view active products" on public.products for select to anon,authenticated using (active=true or public.is_store_owner());
create policy "owner manage products" on public.products for all to authenticated using (public.is_store_owner()) with check (public.is_store_owner());
create policy "customers can place orders" on public.orders for insert to anon,authenticated with check (status='pending');
create policy "owner can view orders" on public.orders for select to authenticated using (public.is_store_owner());
create policy "owner can update orders" on public.orders for update to authenticated using (public.is_store_owner()) with check (public.is_store_owner());
create policy "visitor logging function handles writes" on public.visits for insert to anon,authenticated with check (false);
create policy "owner can read visits" on public.visits for select to authenticated using (public.is_store_owner());
