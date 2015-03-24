drop schema if exists fibonacci cascade;
create schema fibonacci;
set search_path = fibonacci;

create or replace function 
	fib(n integer)
returns decimal(1000,0)
as $$
	declare counter integer := 0;
	declare a decimal(1000,0) := 0;
	declare b decimal(1000,0) := 1;
begin
	if (n < 1) 
	then
		return 0;
	end if;
	loop
		exit when counter = n;
		counter := counter + 1;
		select b,a+b into a,b;
	end loop;
	return a;
end;
$$ language plpgsql;

select fib(4);