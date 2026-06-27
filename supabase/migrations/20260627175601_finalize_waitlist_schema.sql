alter table waitlist
add column if not exists user_agent text;
alter table waitlist
add column if not exists ip_hash text;
alter table waitlist
add column if not exists updated_at timestamptz default now();
