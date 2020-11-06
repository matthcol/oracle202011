select * from v$database; -- mode archivelog/noarchivelog
-- en sysdba
shutdown immediate
startup mount
alter database archivelog;
alter database open;
select * from v$database;
-- rman 

-- rotation des log
alter system switch logfile;
-- lire : DEFAULT_PERMANENT_TABLESPACE, DEFAULT_PERMANENT_TABLESPACE
select * from database_properties;
create user moviemngr identified by password;
select * from dba_users where username like 'MOVIE%'; -- DEFAULT_TABLESPACE et TEMPORARY_TABLESPACE repris de DATABASE_PROPERTIES
drop user moviemngr;
create user moviemngr identified by password
    default tablespace sysaux
    temporary tablespace temp; 
select * from dba_users where username like 'MOVIE%';
create table movie.franchise(name varchar2(50));
select * from dba_tables where owner = 'MOVIE';
drop table movie.franchise;
--
DROP TABLESPACE TB_FRANCHISE;
CREATE TABLESPACE TB_FRANCHISE 
    DATAFILE 
        'C:\app\oracle\oradata\ORAWIN19\TB_FRANCHISE01.DBF' SIZE 100M AUTOEXTEND ON NEXT 100M;
        
select * from dba_tablespaces;
select * from dba_data_files; -- bytes, autoextensible, maxbytes
select * from dba_temp_files;
--
create table movie.franchise(
    name varchar2(50)
) TABLESPACE tb_franchise;
select * from dba_tables where owner = 'MOVIE';
select * from dba_indexes where owner = 'MOVIE';
-- idem pour les indexes
CREATE TABLESPACE IDX_TITLE 
    DATAFILE 
        'C:\app\oracle\oradata\ORAWIN19\IDX_TITLE01.DBF' SIZE 100M AUTOEXTEND ON NEXT 100M;
alter user movie quota unlimited on tb_franchise quota unlimited on idx_title;
CREATE INDEX movie.IDX_TITLE ON movie.movies(title) tablespace idx_title;
drop index movie.idx_title;
insert into movie.franchise (name) values ('James Bond 007');
-- add datafile to existing tablespace
ALTER TABLESPACE IDX_TITLE
    ADD DATAFILE 'C:\app\oracle\oradata\ORAWIN19\IDX_TITLE02.DBF'
    SIZE 100M
    AUTOEXTEND ON NEXT 100M;
-- segments and extents
select * from dba_segments where owner = 'MOVIE' order by segment_type;
select * from dba_extents where owner = 'MOVIE';

-- control files
show parameters control
select * from v$controlfile;
alter system set control_files = 'C:\APP\ORACLE\ORADATA\ORAWIN19\CONTROL01.CTL', 'C:\APP\ORACLE\RECOVERY_AREA\ORAWIN19\CONTROL\CONTROL02.CTL' SCOPE=SPFILE;

-- recovery_area: db_recovery_file_dest_size, db_recovery_file_dest
show parameter db_rec
alter system set db_recovery_file_dest_size=100G scope=memory;
alter system set db_recovery_file_dest_size=100G scope=both;
-- log_archive_dest
show parameter log

-- privileges system
create user fan identified by password; -- schema avec inclus create synonym (private)
grant connect to fan; -- role qui contient create session 

create user authmngr identified by password;
grant connect, resource to authmngr; -- resource: create table, index, trigger (pas les view)

grant create view to movie;
grant create view to movie with admin option;

-- privleges objects
grant select on movie.stars to fan;
revoke select on movie.stars from fan;
grant select, update on movie.movies to fan; 
revoke select, update on movie.movies from fan; 
grant select, update(synopsis) on movie.movies to fan;
grant select, insert on movie.v_movies_current_year to fan;

-- transmission des droits
create user critique identified by password;
grant connect to critique;
create user jury identified by password;
grant connect to jury;

-- role
grant create role to movie;

-- role de connexions
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/admin/getting-started-with-database-administration.html#GUID-10287280-C2E4-4FB1-ABF9-993327419603
create user dbadmin identified by password;
grant sysdba to dbadmin;   -- à donner en tant que sysdba/ connect non obligatoire
grant connect to dbadmin;
grant resource to dbadmin;

-- qui a le droit ?
select * from user_role_privs; -- for current user system: dba
select * from dba_role_privs where grantee in ('MOVIE', 'FAN', 'CRITIQUE', 'JURY') order by grantee;
select * from role_role_privs where role in ('DBA', 'CONNECT', 'RESOURCE', 'MOVIE_READER', 'MOVIE_MNGR');
select * from role_sys_privs where role in ('DBA', 'CONNECT', 'RESOURCE', 'MOVIE_READER', 'MOVIE_MNGR');
select * from role_tab_privs where role in ('DBA', 'CONNECT', 'RESOURCE', 'MOVIE_READER', 'MOVIE_MNGR');
select * from DBA_SYS_PRIVS where grantee in ('CONNECT', 'RESOURCE', 'MOVIE_READER', 'MOVIE_MNGR') order by grantee;


-- changer les redo logs
-- 1. insert 3 new groups of redo logs
-- 2. provoke rotations to advance current toward a new group
-- 3. delete old ones

select * from v$log;
select * from v$logfile;

ALTER DATABASE
ADD LOGFILE GROUP 4 ('C:\APP\ORACLE\ORADATA\ORAWIN19\REDO04.LOG')
SIZE 4M;
ALTER DATABASE
ADD LOGFILE GROUP 5 ('C:\APP\ORACLE\ORADATA\ORAWIN19\REDO05.LOG')
SIZE 4M;
ALTER DATABASE
ADD LOGFILE GROUP 6 ('C:\APP\ORACLE\ORADATA\ORAWIN19\REDO06.LOG')
SIZE 4M;


ALTER SYSTEM SWITCH LOGFILE;
select * from v$log;
ALTER DATABASE DROP LOGFILE GROUP 1;
ALTER DATABASE DROP LOGFILE GROUP 2;
ALTER DATABASE DROP LOGFILE GROUP 3;


-- rman
backup database;
backup database plus archivelog;
backup database plus archivelog delete all input;
backup archivelog all delete all input;

list backup of database completed between '2020-11-04 10:00:00' and '2020-11-04 16:00:00';
list backup of database completed after '2020-11-04 10:00:00';
list backup of database completed before '2020-11-04 16:00:00';
list backup of database summary;
report obsolete;
show retention policy;  -- CONFIGURE RETENTION POLICY TO REDUNDANCY 1;
report obsolete REDUNDANCY 4;
CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
delete obsolete; -- interactif
delete noprompt obsolete;

-- restore/recover scenarii
list incarnation;  -- rman
select * from v$database_incarnation;
select * from v$log;
select group#, sequence#, first_change#, status from v$log;
select sequence#, FIRST_CHANGE#, FIRST_TIME from v$loghist;
-- current scn
select current_scn from v$database;
select timestamp_to_scn(sysdate) from dual;
select first_change#, timestamp_to_scn(sysdate) as CURR_SCN from v$log where status = 'CURRENT';
-- restore./recover
restore database;
recover database;
-- backup avec script
rman target sys/password @backup_cinema_full.rman
list backup of database summary;
list backup of archivelog all summary;
list backup of controlfile summary;
-- restore/recover avec until seq/scn/time
alter database open resetlogs;

-- restore controlefile si mode autobackup
restore controlfile from autobackup;
restore controlfile from 'C:\app\oracle\recovery_area\ORAWIN19\AUTOBACKUP\2020_11_05\O1_MF_S_1055680560_HT7RX07Z_.BKP';

-- simulation reset database
drop user movie cascade;
select * from dba_tablespaces;
drop tablespace TB_FRANCHISE;
drop tablespace IDX_TITLE;

show parameter db_re
alter system set db_recovery_file_dest_size=8G scope=spfile;

-- restore spfile
 restore SPFILE 
    TO 'C:\app\oracle\product\WINDOWS.X64_193000_db_home\database\SPFILEORAWIN19_new.ORA' 
    from 'C:\app\oracle\recovery_area\ORAWIN19\AUTOBACKUP\2020_11_05\O1_MF_S_1055688838_HT80ZPYH_.BKP';
restore controlfile from 'C:\app\oracle\recovery_area\ORAWIN19\AUTOBACKUP\2020_11_05\O1_MF_S_1055688838_HT80ZPYH_.BKP';
-- from spfile
startup NOMOUNT PFILE='C:\app\oracle\product\WINDOWS.X64_193000_db_home\database\init_tmp.ora'
restore spfile from 'C:\app\oracle\recovery_area\ORAWIN19\AUTOBACKUP\2020_11_05\O1_MF_S_1055688838_HT80ZPYH_.BKP';
restore controlfile from 'C:\app\oracle\recovery_area\ORAWIN19\AUTOBACKUP\2020_11_05\O1_MF_S_1055688838_HT80ZPYH_.BKP';

-- reintegrer des anciens backups dans le catalogue
catalog start with 'C:\app\oracle\recovery_area\ORAWIN19\BACKUPSET\2020_11_05\' NOPROMPT;
list backup of database summary;

-- refaire le catalogue à la main
crosscheck backup;
list expired backup of database summary;
delete expired backup;
delete NOPROMPT expired backup;




















 





















    
    











