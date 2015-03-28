drop schema if exists var cascade;
create schema var;
set search_path = var;

create or replace function 
	unnest_v(variadic arr anyarray)
returns setof anyelement
as $$
begin
	return query select unnest(arr);
end;
$$ language plpgsql;

select unnest_v(1, 2, 3, 4);