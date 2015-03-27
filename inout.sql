create or replace function positives (
	inout a int,
	inout b int,
	inout c int)
as $$
begin
	if a < 0 then a = null; end if;
	if b < 0 then b = null; end if;
	if c < 0 then c = null; end if;
end;
$$ language plpgsql;

select positives(-1, 2, 3);