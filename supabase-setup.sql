-- 时间手账 · Supabase 数据库初始化脚本
-- 用法：Supabase 控制台 → 左侧 SQL Editor → New query → 粘贴全部 → Run

-- 数据表：每个用户一行，存全部应用数据
create table if not exists tt_data (
  id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

-- 开启行级安全：每个人只能读写自己的数据
alter table tt_data enable row level security;

create policy "own_select" on tt_data
  for select using (auth.uid() = id);

create policy "own_insert" on tt_data
  for insert with check (auth.uid() = id);

create policy "own_update" on tt_data
  for update using (auth.uid() = id);
