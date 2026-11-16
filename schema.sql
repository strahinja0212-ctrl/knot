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

-- Folders (added Nov 15 2026): a folder sits inside another folder, a project, or at the top level.
create table if not exists public.folders (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null default '',
  parent_id uuid,
  project_id uuid,
  color text,
  position int default 0,
  created_at timestamptz,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  synced_at timestamptz not null default now()
);
alter table public.folders enable row level security;
drop policy if exists own_rows on public.folders;
create policy own_rows on public.folders for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop trigger if exists knot_touch on public.folders;
create trigger knot_touch before insert or update on public.folders for each row execute function public.knot_touch();
create index if not exists folders_sync_idx on public.folders (user_id, synced_at);
alter publication supabase_realtime add table public.folders;
alter table public.notes add column if not exists folder_id uuid;

-- Spaced repetition review state (added Nov 15 2026). One row per card once it has been reviewed;
-- the id is a hash of note id + question text, so cards themselves live in note text.
create table if not exists public.cards (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  note_id uuid,
  due timestamptz,
  ivl real default 0,
  ease real default 2.5,
  reps int default 0,
  lapses int default 0,
  created_at timestamptz,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  synced_at timestamptz not null default now()
);
alter table public.cards enable row level security;
drop policy if exists own_rows on public.cards;
create policy own_rows on public.cards for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop trigger if exists knot_touch on public.cards;
create trigger knot_touch before insert or update on public.cards for each row execute function public.knot_touch();
create index if not exists cards_sync_idx on public.cards (user_id, synced_at);
alter publication supabase_realtime add table public.cards;

-- Subprojects (added Nov 16 2026): a project can sit inside another project.
alter table public.projects add column if not exists parent_id uuid;

-- Quiz results (added Nov 16 2026). Quizzes live in note text (```quiz blocks); one row per attempt.
create table if not exists public.quiz_results (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  note_id uuid,
  score int default 0,
  total int default 0,
  passed boolean default false,
  created_at timestamptz,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  synced_at timestamptz not null default now()
);
alter table public.quiz_results enable row level security;
drop policy if exists own_rows on public.quiz_results;
create policy own_rows on public.quiz_results for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop trigger if exists knot_touch on public.quiz_results;
create trigger knot_touch before insert or update on public.quiz_results for each row execute function public.knot_touch();
create index if not exists quiz_results_sync_idx on public.quiz_results (user_id, synced_at);
alter publication supabase_realtime add table public.quiz_results;
