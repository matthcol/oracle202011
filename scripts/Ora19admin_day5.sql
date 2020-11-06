-- Data Pump
select * from dba_datapump_jobs;
select * from dba_directories;
create directory EXPORT_DIR as 'C:\D\backup';
select * from dba_directories;

-- drop master table d'un job
select * from export_full_job;
select 'drop table ' || job_name || ';' from dba_datapump_jobs;
drop table EXPORT_FULL_JOB;

-- scripts expdp
expdp system/password FULL=YES DIRECTORY=EXPORT_DIR DUMPFILE=database_exp_%Y%M%D.dmp LOGFILE=database_exp.log
expdp system/password PARFILE=export_full.par
expdp system/password ATTACH=EXPORT_FULL_JOB
    help
    kill_job
    (stop_job)
    CONTINUE_CLIENT
-- REUSE_DUMPFILES=YES pour ecraser
expdp system/password PARFILE=export_full_keep.par
;
grant all on directory EXPORT_DIR to movie;
expdp movie/password PARFILE=export_movies2020_data.par

-- import
impdp movie/password DIRECTORY=EXPORT_DIR DUMPFILE=DATABASE_EXP_20201106.DMP TABLES=movie.play
impdp system/password DIRECTORY=EXPORT_DIR DUMPFILE=DATABASE_EXP_20201106.DMP TABLES=movie.play TABLE_EXISTS_ACTION=REPLACE
impdp system/password DIRECTORY=EXPORT_DIR DUMPFILE=DATABASE_EXP_20201106.DMP TABLES=movie.movies TABLE_EXISTS_ACTION=REPLACE
drop sequence movie.SEQ_MOVIES_ID;
impdp system/password DIRECTORY=EXPORT_DIR DUMPFILE=DATABASE_EXP_20201106.DMP SCHEMAS=movie INCLUDE=TABLE:"='MOVIES'" INCLUDE=SEQUENCE:"='SEQ_MOVIES_ID'" TABLE_EXISTS_ACTION=REPLACE

drop user movie cascade;
impdp system/password DIRECTORY=EXPORT_DIR DUMPFILE=DATABASE_EXP_20201106.DMP SCHEMAS=movie
impdp movie/password DIRECTORY=EXPORT_DIR DUMPFILE=DATABASE_EXP_20201106.DMP CONTENT=DATA_ONLY TABLES=play TABLE_EXISTS_ACTION=TRUNCATE
impdp movie/password DIRECTORY=EXPORT_DIR DUMPFILE=DATABASE_EXP_20201106.DMP REMAP_TABLE=play:play2 TABLES=play
impdp movie/password DIRECTORY=EXPORT_DIR DUMPFILE=DATABASE_EXP_20201106.DMP REMAP_SCHEMA=movie:movie2 SCHEMAS=movie

select 'MOVIE_PLAY', count(*) from movie.play -- 68953
union
select 'MOVIE2_PLAY', count(*) from movie2.play;

select * from movie2.play p2 where not exists (select * from movie.play p where p.id_actor = p2.id_actor and p.id_movie = p2.id_movie);

-- db link private
create database link db_movie_test
connect to movie identified by password 
using 'orawin19b';

-- attention tous les utilisateurs ont les droits de movie sur la base externe
create public database link db_movie_test
connect to movie identified by password 
using 'orawin19b';

create synonym movie.play_test for play@db_movie_test;

alter session close database link db_movie_test;
drop database link db_movie_test; 

select count(*) from movie.play@db_movie_test;
select count(*) from play@db_movie_test;

--
select * from v$session where username = 'MOVIE';
select * from v$session where username IN ( 'MOVIE', 'FAN', 'SYSTEM');
select SID, SERIAL#, USERNAME, PROGRAM from v$session where username IN ( 'MOVIE', 'FAN', 'SYSTEM');
alter system kill session '133,2822'; -- SID, SERIAL#
alter system kill session '8,9762';
--
select * from v$lock where SID in (select SID from v$session where username = 'MOVIE');
-- type TM+TX pour transaction avec DML en cours + lmode : 6 pour celui qui tient le verrou et 0 pour ceux qui attendent


select * from v$sql;
select * from v$sqltext;















-- lecture:
-- https://www.oracle-scripts.net/cleanup-orphaned-datapump-jobs/
