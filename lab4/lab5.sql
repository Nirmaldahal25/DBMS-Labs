DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS user_logs;

CREATE TABLE users(
	id INT PRIMARY KEY,
	uname VARCHAR(80) NOT NULL,
	email VARCHAR(80) NULL,
	fname VARCHAR(30) NULL,
	lname VARCHAR(30) NULL,
	dob DATE NULL,
	age INT NULL
);

CREATE TABLE user_logs(
	id SERIAL PRIMARY KEY,
	old_value VARCHAR(30),
	new_value VARCHAR(30),
	description VARCHAR(250) NULL,
	log_time TIMESTAMP NULL
);

INSERT INTO users 
VALUES
	(1, 'ramhari', 'ramhari@hotmail.com', 'ram','hari','2001-01-10',21),
	(2, 'krishnashyam', 'krishnashyam@yahoo.com', 'krishna', 'shyam', '2010-10-10', 12);
	

-- Create the following functions
-- Function that returns the full name of the user with the given ID
DROP FUNCTION IF EXISTS get_fullname;
CREATE OR REPLACE FUNCTION get_fullname(uid INT)
RETURNS CHARACTER VARYING
LANGUAGE plpgsql 
AS
$$
	DECLARE fullname CHARACTER VARYING;
	BEGIN
		SELECT fname|| ' '||lname INTO fullname FROM users WHERE users.id = uid;
		RETURN fullname;
	END
$$;
SELECT get_fullname(1);

-- Function that returns the number of users
DROP FUNCTION IF EXISTS get_numberofusers;
CREATE FUNCTION get_numberofusers()
RETURNS INTEGER
LANGUAGE plpgsql
AS
$$
	BEGIN
		RETURN (SELECT COUNT(*) FROM users);
	END
$$;
SELECT get_numberofusers();

-- Function that returns the age of the user with the given ID
DROP FUNCTION IF EXISTS get_age;
CREATE FUNCTION get_age(uid INT)
RETURNS INT
LANGUAGE plpgsql
AS
$$
	DECLARE
		dateofbirth DATE;
	BEGIN
		SELECT dob INTO dateofbirth FROM users WHERE users.id = uid;
		IF dateofbirth IS NOT NULL THEN
			RETURN EXTRACT(YEAR FROM AGE(CURRENT_DATE, dateofbirth));
		ELSE
			RAISE EXCEPTION 'dob is null';
		END IF;
	END
$$;
SELECT get_age(1);


ALTER TABLE users ADD COLUMN fullname VARCHAR(60);


-- Create the following stored procedures
-- SP to update the full name of the user with the given ID
DROP PROCEDURE IF EXISTS update_fullname;
CREATE PROCEDURE update_fullname (fulln VARCHAR(60), uid INT)
LANGUAGE plpgsql
AS
$$
	BEGIN
		UPDATE users SET fullname = fulln WHERE users.id = uid;
	END
$$;

CALL update_fullname('Radhe Shyam', 1);
SELECT fullname FROM users WHERE users.id = 1;
--Radhe Shyam


-- SP to update the age of the user with the given ID
DROP PROCEDURE IF EXISTS update_age;
CREATE PROCEDURE update_age(dateofbirth DATE, uid  INT)
LANGUAGE plpgsql
AS
$$
	DECLARE newage INTEGER;
	BEGIN 
		UPDATE users SET dob = dateofbirth WHERE users.id = uid;
		SELECT get_age(uid) INTO newage;
		UPDATE users SET age = newage WHERE users.id = uid;
	END
$$;

--Before: 20
CALL update_age('1990-01-01', 1);
SELECT age FROM users WHERE users.id = 1;
--After: 32


-- Create the following triggers
-- Trigger that populates full name on adding a new user
DROP TRIGGER IF EXISTS populate_fullname ON users;
DROP FUNCTION IF EXISTS populate_fullname_trigger;

CREATE FUNCTION populate_fullname_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
	BEGIN
		NEW.fullname = NEW.fname|| ' ' || NEW.lname;
		RETURN NEW;
	END
$$;
CREATE TRIGGER populate_fullname BEFORE INSERT ON users FOR EACH ROW EXECUTE PROCEDURE populate_fullname_trigger();


-- Trigger that populates age on adding a new user
DROP TRIGGER IF EXISTS populate_age ON users;
DROP FUNCTION IF EXISTS populate_age_trigger;

CREATE FUNCTION populate_age_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
	BEGIN
		NEW.age = EXTRACT(YEAR FROM AGE(CURRENT_DATE, NEW.dob));
		return NEW;
	END
$$;
CREATE TRIGGER populate_age BEFORE INSERT ON users FOR EACH ROW EXECUTE PROCEDURE populate_age_trigger();


-- Trigger that inserts a new row in user_logs if any value is updated in users table. If last name of a user is updated, the following values must be inserted into the user_logs table:
-- <old last name>, <new last name>, 'Last name updated', current time
DROP TRIGGER IF EXISTS populate_user_logs_trigger ON users;
DROP FUNCTION IF EXISTS populate_user_logs;

CREATE FUNCTION populate_user_logs()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
	BEGIN
		IF OLD.lname <> NEW.lname THEN
			INSERT INTO user_logs(old_value, new_value, description, log_time) VALUES(OLD.lname, NEW.lname, 'Last name Updated', CURRENT_TIMESTAMP);
		END IF;	
		IF OLD.fname <> NEW.fname THEN
			INSERT INTO user_logs(old_value, new_value, description, log_time) VALUES(OLD.fname, NEW.fname, 'first name Updated', CURRENT_TIMESTAMP);
		END IF;	
		IF OLD.dob <> NEW.dob THEN
			INSERT INTO user_logs(old_value, new_value, description, log_time) VALUES(OLD.dob, NEW.dob, 'Age Updated', CURRENT_TIMESTAMP);
		END IF;
		RETURN NEW;
	END
$$;
CREATE TRIGGER populate_user_logs_trigger AFTER UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE populate_user_logs();


--Triggers Check 


INSERT INTO users(id, uname, email, fname,lname,dob) VALUES(3, 'Radha Krishna', 'radhe@gmail.com', 'Radha', 'Krishna', '1999-10-20'); 
SELECT * FROM users WHERE id = 3;
--fullname = Radha Krishna, age = 22

UPDATE users SET lname = 'Shyam' WHERE users.id = 3; 
UPDATE users SET fname = 'Hari' WHERE users.id = 3;

SELECT * FROM user_logs;
-- id = 1, old_value = Krishna, new_value = Shyam, description = Last name Updated, log_time = CURRENT_TIMESTAMP()
--id = 2, old_value = Krishna, new_value = Hari, description = first name Updated, log_time = CURRENT_TIMESTAMP() 
SELECT * FROM users WHERE id = 3;
--lname = Shyam





