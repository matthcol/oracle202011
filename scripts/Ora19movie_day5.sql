select * from movies where year = extract(year from sysdate);

drop table play;

alter sequence SEQ_MOVIES_ID restart start with 100;
select SEQ_MOVIES_ID.nextval from dual;

select count(*) from movies;

select count(*) from play; -- 68958
select * from play where role like 'Sarah Connor';
delete from play where role like 'Sarah Connor';
commit;
select 'PLAY', count(*) from play -- 68953
union
select 'PLAY2', count(*) from play2;

-- PS:
select * from play p join stars s on p.id_actor = s.id where role like 'Sarah Connor';

select count(*) from play@db_movie_test;
select count(*) from play_test;

alter sequence seq_stars_id restart start with 100000000;
insert into stars (name) values ('Joe Baiden');
select * from movies where title = 'Pulp Fiction'; -- 110912
update movies set synopsis = 'Very Goog'  where id = 110912;
commit;


