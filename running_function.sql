-- run as superuser
drop schema if exists running cascade;
create schema running;
grant all privileges on schema running to hannu;
set search_path = running;

create view running_queries as
	select
		current_timestamp - query_start as runtime, pid, usename, waiting, query
	from pg_stat_activity
	order by 1 desc
	limit 10;

create or replace function
	running_queries(rows int, qlen int)
returns
	setof running_queries
as $$
begin
	return query
		select
			runtime, pid, usename, waiting,
			(case
				when
					(usename=session_user) or (select usesuper from pg_user where usename = session_user)
				then
					substring(query, 1, qlen)
				else
					substring(ltrim(query), 1, 6) || ' ***' 
			end)
		as query
		from running_queries
		order by 1 desc
		limit rows;
end;
$$ language plpgsql security definer;