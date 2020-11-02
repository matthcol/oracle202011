---------------------------------------------------------------
--  TRIGGERS FOR AUTO ID ---------------------------------------
----------------------------------------------------------------

-- ID TABLE stars


CREATE OR REPLACE TRIGGER gen_stars_id
BEFORE INSERT ON stars
FOR EACH ROW
BEGIN
	:new.id := seq_stars_id.nextval;
END;
/

-- ID TABLE movies


CREATE OR REPLACE TRIGGER gen_movies_id
BEFORE INSERT ON movies
FOR EACH ROW
BEGIN
	:new.id := seq_movies_id.nextval;
END;
/
