-- CM05 2026 | Esquema privado para Supabase
-- Ejecutar una sola vez en SQL Editor de un proyecto Supabase NUEVO.
-- NO incluir claves service_role en GitHub ni en el navegador.

create table if not exists public.cm05_groups (
  id integer primary key,
  tema text not null default 'Tema pendiente',
  integrantes text not null default '',
  pregunta_sugerida text not null default '',
  created_at timestamptz not null default now()
);
create table if not exists public.cm05_members (
  email text primary key,
  group_id integer references public.cm05_groups(id) on delete cascade,
  teacher boolean not null default false,
  check (teacher = true or group_id is not null)
);
create table if not exists public.cm05_answers (
  group_id integer not null references public.cm05_groups(id) on delete cascade,
  field_key text not null,
  body jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid,
  primary key (group_id, field_key),
  check (char_length(field_key) between 1 and 100)
);
create index if not exists cm05_members_group_id_idx on public.cm05_members(group_id);

-- Funciones de permisos: ejecutadas como propietario para evitar recursión en RLS.
create schema if not exists cm05_private;
revoke all on schema cm05_private from public, anon;
grant usage on schema cm05_private to authenticated;

create or replace function cm05_private.cm05_is_teacher()
returns boolean language sql stable security definer set search_path = ''
as $$ select exists (
  select 1 from public.cm05_members
  where lower(email)=lower(auth.jwt()->>'email') and teacher = true and auth.uid() is not null
); $$;
create or replace function cm05_private.cm05_my_group()
returns integer language sql stable security definer set search_path = ''
as $$ select group_id from public.cm05_members
  where lower(email)=lower(auth.jwt()->>'email') and teacher = false and auth.uid() is not null limit 1; $$;
revoke all on function cm05_private.cm05_is_teacher() from public, anon;
revoke all on function cm05_private.cm05_my_group() from public, anon;
grant execute on function cm05_private.cm05_is_teacher() to authenticated;
grant execute on function cm05_private.cm05_my_group() to authenticated;

alter table public.cm05_groups enable row level security;
alter table public.cm05_members enable row level security;
alter table public.cm05_answers enable row level security;

grant select, insert, update, delete on public.cm05_groups, public.cm05_members, public.cm05_answers to authenticated;
revoke all on public.cm05_groups, public.cm05_members, public.cm05_answers from anon;

drop policy if exists cm05_groups_select on public.cm05_groups;
create policy cm05_groups_select on public.cm05_groups for select to authenticated
using (cm05_private.cm05_is_teacher() or id=cm05_private.cm05_my_group());
drop policy if exists cm05_groups_insert on public.cm05_groups;
create policy cm05_groups_insert on public.cm05_groups for insert to authenticated
with check (cm05_private.cm05_is_teacher());
drop policy if exists cm05_groups_update on public.cm05_groups;
create policy cm05_groups_update on public.cm05_groups for update to authenticated
using (cm05_private.cm05_is_teacher()) with check(cm05_private.cm05_is_teacher());

drop policy if exists cm05_members_select on public.cm05_members;
create policy cm05_members_select on public.cm05_members for select to authenticated
using (cm05_private.cm05_is_teacher() or lower(email)=lower(auth.jwt()->>'email'));
drop policy if exists cm05_members_insert on public.cm05_members;
create policy cm05_members_insert on public.cm05_members for insert to authenticated
with check (cm05_private.cm05_is_teacher());
drop policy if exists cm05_members_update on public.cm05_members;
create policy cm05_members_update on public.cm05_members for update to authenticated
using(cm05_private.cm05_is_teacher()) with check(cm05_private.cm05_is_teacher());
drop policy if exists cm05_members_delete on public.cm05_members;
create policy cm05_members_delete on public.cm05_members for delete to authenticated
using(cm05_private.cm05_is_teacher());

drop policy if exists cm05_answers_select on public.cm05_answers;
create policy cm05_answers_select on public.cm05_answers for select to authenticated
using (cm05_private.cm05_is_teacher() or group_id=cm05_private.cm05_my_group());
drop policy if exists cm05_answers_insert on public.cm05_answers;
create policy cm05_answers_insert on public.cm05_answers for insert to authenticated
with check (cm05_private.cm05_is_teacher() or group_id=cm05_private.cm05_my_group());
drop policy if exists cm05_answers_update on public.cm05_answers;
create policy cm05_answers_update on public.cm05_answers for update to authenticated
using (cm05_private.cm05_is_teacher() or group_id=cm05_private.cm05_my_group())
with check (cm05_private.cm05_is_teacher() or group_id=cm05_private.cm05_my_group());

-- Los cambios de respuestas llegan en tiempo real solo a clientes
-- autorizados a leer las filas, por sus políticas RLS.
do $$
begin
 if not exists(select 1 from pg_publication_tables
               where pubname='supabase_realtime'
                 and schemaname='public' and tablename='cm05_answers') then
   alter publication supabase_realtime add table public.cm05_answers;
 end if;
end $$;

-- PASO DE ADMINISTRADOR (ejecutar SOLO en Supabase SQL Editor):
-- insert into public.cm05_members(email,group_id,teacher)
-- values ('TU_CORREO_VERIFICADO',null,true)
-- on conflict(email) do update set teacher=true, group_id=null;
-- Luego entrar por email/OTP y utilizar el panel docente.
