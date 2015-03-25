drop schema if exists fibonacci cascade;
create schema fibonacci;
set search_path = fibonacci;

create or replace function 
	fibonacci_seq(num integer)
returns setof integer
as $$
	declare a int := 0;
	declare b int := 1;
begin
	if (num <= 0) 
	then
		return;
	end if;
	return next a;
	loop
		exit when num <= 1;
		return next b;
		num = num - 1;
		select b,a+b into a,b;
	end loop;
end;
$$ language plpgsql;

select fibonacci_seq(5);