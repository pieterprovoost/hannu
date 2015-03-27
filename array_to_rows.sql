drop schema if exists rows cascade;
create schema rows;
set search_path = rows;

create or replace function array_to_rows(array_in anyarray)
	returns table(row_out anyelement)
as $$
begin
	for i in 1.. array_upper(array_in, 1) loop
		row_out = array_in[i];
		return next;
	end loop;	
end;
$$ language plpgsql;

select array_to_rows('{1, 2, 3}'::int[]);
select array_to_rows('{"1970-1-1", "2012-12-12"}'::date[]);

create table mydata(id serial primary key, data text);
insert into mydata values(1, 'one'), (2, 'two');
select array_to_rows(array(select m from mydata m));
select * from array_to_rows (array(select m from mydata m));

select unnest('{{1, 2, 3}, {4, 5, 6}}'::int[]);