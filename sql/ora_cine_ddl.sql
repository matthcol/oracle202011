---------------------------------------------------------------------------
-- TABLES
---------------------------------------------------------------------------

create table stars(
	id number constraint pk_stars primary key,
	name varchar2(150) NOT NULL,
	birthdate date NULL
);

create table movies(
	id number constraint pk_movies primary key,	
	title varchar2(250) NOT NULL,
	year number(4) constraint chk_movies_year check (year >= 1888),
	duration number(4) NULL,
	genres varchar2(200) DEFAULT 'Drama',
	synopsis varchar2(2000) NULL,
	poster_uri varchar2(300) NULL,
	id_director NULL constraint fk_movies references stars(id)
);

create table play(
	id_movie constraint fk1_play references movies(id),
	id_actor constraint fk2_play references stars(id),
	role varchar2(100),
	constraint pk_play primary key (id_movie,id_actor)
);


---------------------------------------------------------------
--  Sequences FOR AUTO ID ---------------------------------------
----------------------------------------------------------------

CREATE SEQUENCE seq_stars_id;
CREATE SEQUENCE seq_movies_id;
