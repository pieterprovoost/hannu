drop schema if exists record cascade;
create schema record;
set search_path = record;

create table application_settings_old (
	version varchar(200),
	key varchar(200),
	value varchar(2000)
);

insert into application_settings_old values ('1', 'full_name', 'foo');
insert into application_settings_old values ('1', 'description', 'bar');
insert into application_settings_old values ('1', 'print_certificate', 'true');
insert into application_settings_old values ('1', 'show_advertisements', 'true');
insert into application_settings_old values ('1', 'show_splash_screen', 'true');
insert into application_settings_old values ('2', 'full_name', 'foo');
insert into application_settings_old values ('2', 'description', 'bar');
insert into application_settings_old values ('2', 'print_certificate', 'false');
insert into application_settings_old values ('2', 'show_advertisements', 'false');
insert into application_settings_old values ('2', 'show_splash_screen', 'true');

create table application_settings_new (
	version varchar(200),
	full_name varchar(2000),
	description varchar(2000),
	print_certificate varchar(2000),
	show_advertisements varchar(2000),
	show_splash_screen varchar(2000)
);

create or replace function
	flatten_application_settings(app_version varchar(200))
returns setof application_settings_new
as $$
begin
	-- create a temporary table to hold a single row of data
	if exists (select relname from pg_class where relname='tmp_settings')
	then
		truncate table tmp_settings;
	else
		create temp table tmp_settings (like application_settings_new);
	end if;

	-- the row will contain all of the data for this application version
	insert into tmp_settings (version) values (app_version);

	-- add the details to the record for this application version
	update tmp_settings
	set
		full_name = (
			select value
			from application_settings_old 
			where version = app_version and key='full_name'),
		description = (
			select value
			from application_settings_old
			where version = app_version and key='description'),
		print_certificate = (
			select value
			from application_settings_old 
			where version = app_version and key='print_certificate'),
		show_advertisements = (
			select value
			from application_settings_old
			where version = app_version and key='show_advertisements'),
		show_splash_screen = (
			select value
			from application_settings_old
			where version = app_version and key='show_splash_screen');
	
	-- hand back the results to the caller
	return query select * from tmp_settings;
end; 
$$ language plpgsql;

insert into application_settings_new
	select (flatten_application_settings(version)).*
	from (
		select version
		from application_settings_old
		group by version
	) as versions;