
drop table if exists rsvps cascade;
drop table if exists events cascade;
drop table if exists users cascade;
drop type  if exists rsvp_status cascade;

create type rsvp_status as enum ('yes','no','maybe');

create table users (
  id         bigserial primary key,
  name       text not null,
  email      text not null unique,
  created_at timestamptz not null default now()
);

create table events (
  id          bigserial primary key,
  title       text not null,
  description text,
  date        timestamptz not null,
  city        text not null,
  created_by  bigint references users(id) on delete set null  
);

create table rsvps (
  id        bigserial primary key,
  user_id   bigint not null references users(id)  on delete cascade, 
  event_id  bigint not null references events(id) on delete cascade, 
  status    rsvp_status not null,
  created_at timestamptz not null default now(),
  unique (user_id, event_id)  
);

insert into users (name, email) values
('Uday kamala',   'uday@example.com'),
('sathwika varma',     'sathwika@example.com'),
('Reshma goud',     'reshma@example.com'),
('Priya Singh',    'priya@example.com'),
('Vikram Rao',     'vikram@example.com'),
('Neha Gupta',     'neha@example.com'),
('Karan ',    'karan@example.com'),
('Ananya ',    'ananya@example.com'),
('Jaideep Das',      'Jaiddep@example.com'),
('Meera Kulkarni', 'meera@example.com');

insert into events (title, description, date, city, created_by) values
('React Meetup',        'Talks + networking',        now() + interval '5 days',  'Bengaluru', 1),
('Postgres Workshop',   'Hands-on with SQL',         now() + interval '9 days',  'Hyderabad', 2),
('Startup Pitch Night', 'Early-stage pitches',       now() + interval '12 days', 'Mumbai',    3),
('Design Systems 101',  'UI kits & tokens',          now() + interval '15 days', 'Pune',      4),
('AI & Supabase',       'LLMs with row-level rules', now() + interval '20 days', 'Chennai',   5);

insert into rsvps (user_id, event_id, status) values
(1,1,'yes'), (2,1,'maybe'), (3,1,'no'), (4,1,'yes'),
(5,2,'yes'), (6,2,'maybe'), (7,2,'yes'), (8,2,'no'),
(9,3,'maybe'), (10,3,'yes'), (1,3,'no'), (2,3,'yes'),
(3,4,'yes'), (4,4,'maybe'), (5,4,'yes'), (6,4,'no'),
(7,5,'yes'), (8,5,'yes'), (9,5,'maybe'), (10,5,'no');

create or replace view v_events_with_counts as
select
  e.id,e.title, e.date,e.city,
  (select count(*) from rsvps r where r.event_id = e.id and r.status='yes')   as yes_count,
  (select count(*) from rsvps r where r.event_id = e.id and r.status='no')    as no_count,
  (select count(*) from rsvps r where r.event_id = e.id and r.status='maybe') as maybe_count
from events e
order by e.date;

create or replace view v_rsvps_detailed as
select r.id, r.event_id, e.title, r.user_id, u.name as user_name, r.status, r.created_at
from rsvps r
join users u  on u.id = r.user_id
join events e on e.id = r.event_id
order by r.created_at desc;

select * from v_events_with_counts;
select * from v_rsvps_detailed limit 20;