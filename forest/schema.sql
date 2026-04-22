-- FOREST — Supabase schema
-- Run this in Supabase SQL editor once per project.

-- ============================================================
-- Tables
-- ============================================================

create table if not exists investments (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  kind         text not null check (kind in ('public','private')),
  ticker       text,                  -- required when kind='public'
  name         text not null,         -- display name (company)
  notes        text,
  created_at   timestamptz not null default now(),
  constraint ticker_required_for_public check (
    kind = 'private' or (ticker is not null and length(ticker) > 0)
  )
);

create index if not exists investments_user_idx on investments(user_id);
create unique index if not exists investments_user_ticker_uniq
  on investments(user_id, ticker) where kind = 'public';

-- Purchase lots.
-- Public: shares + cost_basis_per_share populated; cost_basis_total = shares * cost_basis_per_share.
-- Private: shares/cost_basis_per_share null; cost_basis_total is the amount invested.
create table if not exists lots (
  id                   uuid primary key default gen_random_uuid(),
  user_id              uuid not null references auth.users(id) on delete cascade,
  investment_id        uuid not null references investments(id) on delete cascade,
  shares               numeric,
  cost_basis_per_share numeric,
  cost_basis_total     numeric not null check (cost_basis_total >= 0),
  purchase_date        date not null,
  created_at           timestamptz not null default now()
);

create index if not exists lots_investment_idx on lots(investment_id);
create index if not exists lots_user_idx on lots(user_id);

-- Valuation history for private investments.
-- valuation_amount = current fair-market value of YOUR stake, not the company's post-money.
create table if not exists valuations (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references auth.users(id) on delete cascade,
  investment_id     uuid not null references investments(id) on delete cascade,
  valuation_date    date not null,
  valuation_amount  numeric not null check (valuation_amount >= 0),
  round_name        text,
  notes             text,
  created_at        timestamptz not null default now()
);

create index if not exists valuations_investment_idx on valuations(investment_id);
create index if not exists valuations_user_idx on valuations(user_id);

-- ============================================================
-- Row level security
-- ============================================================

alter table investments enable row level security;
alter table lots        enable row level security;
alter table valuations  enable row level security;

drop policy if exists "own_investments" on investments;
create policy "own_investments" on investments
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_lots" on lots;
create policy "own_lots" on lots
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_valuations" on valuations;
create policy "own_valuations" on valuations
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
