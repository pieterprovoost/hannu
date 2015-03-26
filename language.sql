drop schema if exists language cascade;
create schema language;
set search_path = language;

create or replace function
	installed_languages()
returns setof pg_language
as $$
begin
	return query select * from pg_language;
end;
$$ language plpgsql;

select installed_languages();