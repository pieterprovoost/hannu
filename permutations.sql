drop schema if exists permutations cascade;
create schema permutations;
set search_path = permutations;

create or replace function permutations (
	inout a int,
	inout b int,
	inout c int)
returns setof record
as $$
begin
	return next;
	select b, c into c, b; return next;
	select a, b into b, a; return next;
	select b, c into c, b; return next;
	select a, b into b, a; return next;
	select b, c into c, b; return next;
end;
$$ language plpgsql;

select permutations(1, 2, 3);