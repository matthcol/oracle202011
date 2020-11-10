alter system set db_recovery_file_dest_size = 200G;

show parameter db_reco;
show parameter log_archive_dest;
show parameter db_recove

select * from v$instance;
select * from v$database; --archivelog

select 'log_mode', log_mode as value from v$database
UNION
select name, value from v$parameter where name in ('log_archive_dest', 'db_recovery_file_dest_size', 'db_recovery_file_dest');

select * from dba_datapump_jobs;
select * from EXPORT_MOVIE_DDL_JOB;
drop table EXPORT_MOVIE_DDL_JOB;

select * from dba_directories;

drop directory EXPORT_DIR;
create directory EXPORT_DIR as 'C:\D\Backup2';

alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';
select sysdate, trunc(sysdate) from dual;
select current_date, current_timestamp from dual;

select * from v$database_incarnation;
select * from v$log;
ALTER SYSTEM SWITCH LOGFILE;

select scn_to_timestamp(3466479) from dual;

