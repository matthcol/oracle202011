select * from stars;

update movies set synopsis = '1st James Bond movie' where id=55928;
select * from movies where id=55928;

rollback;
commit;

create view v_movies_current_year as select * from movies where year = extract(year from current_date);

select current_date from dual;

select title from v_movies_current_year where title like 'B%';

select SEQ_MOVIES_ID.nextval from dual;
select SEQ_MOVIES_ID.currval from dual;

select 3 + 4 from dual;

select max(id) from movies;

declare
    last_id number;
begin
    select max(id) into last_id from movies;
    execute immediate 'alter sequence  SEQ_MOVIES_ID restart start with ' || (last_id +1);
end;
/

declare
    last_id number;
begin
    select max(id) into last_id from stars;
    execute immediate 'alter sequence  SEQ_stars_ID restart start with ' || (last_id +1);
end;
/

insert into movies (title, year) values ('No Time To Die', 2021);
select * from movies where year = 2021;
insert into movies (id, title, year) values (12771924, 'No Time To Die', 2021);
delete from movies where year = 2021;
commit;

alter trigger gen_movies_id disable;
alter trigger gen_movies_id enable;

insert into movies (title, year) values ('Mulan', 2020);



