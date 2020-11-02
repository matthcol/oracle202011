drop user movie cascade;

create user movie identified by password 
	default tablespace users
	temporary tablespace temp
	quota unlimited on users;

grant connect,resource to movie;

connect movie/password;

start ora_cine_ddl.sql
-- data
alter session set NLS_DATE_FORMAT='YYYY-MM-DD';
start cine_data_stars.sql
start cine_data_movies.sql
start cine_data_play.sql
-- autoincr ids
start ora_cine_autoid.sql

exit