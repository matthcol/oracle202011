select setval('movie.stars_id_seq',max(id)) from movie.stars;
select setval('movie.movies_id_seq',max(id)) from movie.movies;
select setval('movie.play2_id_seq',max(id)) from movie.play2;
select setval('movie.play3_id_seq',max(id)) from movie.play3;