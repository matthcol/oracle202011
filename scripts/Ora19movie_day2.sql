alter table movies add (
    poster_img blob null
);

drop view v_movies_current_year;
create view v_movies_current_year as select * from movies where year = extract(year from current_date)
with check option;

grant delete on play to fan;
grant select on play to fan with grant option;

grant create view to fan;

-- 1st level
create role movie_reader;
grant select on movies to movie_reader;
grant select on play to movie_reader;
grant select on stars to movie_reader;
-- 2nd level
create role movie_mngr;
grant movie_reader to movie_mngr;
grant insert on movies to movie_mngr;
grant update(genres, synopsis) on movies to movie_mngr;

revoke select on stars from fan;

grant movie_reader to fan;
revoke movie_reader from fan;

grant movie_mngr to fan;

select * from user_role_privs; -- connect, resource, movie_reader, movie_mngr
select * from role_tab_privs where role in ('DBA', 'CONNECT', 'RESOURCE', 'MOVIE_READER', 'MOVIE_MNGR') order by role;

-- transactions to generate archivelog and for backup purpose
delete from play where role = 'James Bond';
commit;

alter sequence seq_movies_id restart start with 100000000;

declare
begin
    for i in 1 .. 10000 loop
        insert into movies (title, year) values ('Terminator ' || i, 2020);
        commit;
    end loop;
end;
/

select count(*) from movies where title like 'Terminator%';


alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';
select sysdate from dual;
select current_date, current_timestamp from dual;




















