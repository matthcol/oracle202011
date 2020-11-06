select * from all_users;
select * from dba_tablespaces;
select * from sys.dba_tablespaces;
select * from v$session where username = 'SYSTEM';


grant create view to movie;

select * from dba_directories;

create user fan identified by password;
grant connect to fan;
grant select on movie.stars to fan;
grant select on movie.v_movies_current_year to fan;
create synonym fan.stars for movie.stars;
create synonym fan.movies for movie.v_movies_current_year;