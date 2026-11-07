-- Knot database schema. Run once in Supabase: SQL Editor -> New query -> paste -> Run.

create table if not exists public.projects (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null default '',
  color text,
  grp text,
  position int default 0,
  created_at timestamptz,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  synced_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  project_id uuid,
  title text not null default '',
  due date,
  due_time text,
  priority int default 4,
  done boolean not null default false,
  done_at timestamptz,
  section text,
  note_id uuid,
  recur text,
  created_at timestamptz,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  synced_at timestamptz not null default now()
);

create table if not exists public.notes (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  project_id uuid,
  folder text,
  title text not null default '',
  body text not null default '',
  pinned boolean not null default false,
  created_at timestamptz,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  synced_at timestamptz not null default now()
);

-- server-side "last changed" stamp, used by devices to fetch only what changed
create or replace function public.knot_touch() returns trigger language plpgsql as $$
begin
  new.synced_at := now();
  return new;
end $$;

do $$
declare t text;
begin
  foreach t in array array['projects', 'tasks', 'notes'] loop
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists own_rows on public.%I', t);
    execute format('create policy own_rows on public.%I for all using (auth.uid() = user_id) with check (auth.uid() = user_id)', t);
    execute format('drop trigger if exists knot_touch on public.%I', t);
    execute format('create trigger knot_touch before insert or update on public.%I for each row execute function public.knot_touch()', t);
    execute format('create index if not exists %I on public.%I (user_id, synced_at)', t || '_sync_idx', t);
  end loop;
end $$;

-- live updates between devices
alter publication supabase_realtime add table public.projects, public.tasks, public.notes;
