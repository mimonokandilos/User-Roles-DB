--------TESTING--------
-- Create DB, TABLES to store user information
DROP DATABASE FIETO; CREATE DATABASE IF NOT EXISTS FIETO;

CREATE TABLE FIETO.USERS (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role ENUM('general', 'moderator', 'admin') NOT NULL DEFAULT 'general'
);


CREATE TABLE FIETO.AUDIT_HISTORY (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  action VARCHAR(255),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user1', 'user1@example.com', 'password1', 'general');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user2', 'user2@example.com', 'password2', 'moderator');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user3', 'user3@example.com', 'password3', 'admin');


use FIETO;
SELECT * FROM USERS;
SHOW TRIGGERS;
--Code language: SQL (Structured Query Language) (sql)

------------------------------------
------STOP HERE---------------------
--have you enabled constraints?-----
-----pax tibi marce-----------------
--IF YES, Begin Testing Sequenc
------------------------------------

-- mysql> select * from users;
-- +----+----------+-------------------+-----------+-----------+
-- | id | username | email             | password  | role      |
-- +----+----------+-------------------+-----------+-----------+
-- |  1 | user1    | user1@example.com | password1 | general   |
-- |  2 | user2    | user2@example.com | password2 | moderator |
-- |  3 | user3    | user3@example.com | password3 | admin     |
-- +----+----------+-------------------+-----------+-----------+
-- 3 rows in set (0.00 sec)

--whout password WORKING
INSERT INTO USERS (username, email, password, role) VALUES ('user4', 'user4@example.com', '', 'general');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('useradminFail', 'useraF@example.com', 'password3', 'admin');
---ERROR 1644 (45000): User must have a password



---testing trigger to make sure every user inserted/updated is insertted to the audit history table
---ENABLE TIGGER FIRST
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('test24', 'user141@example.com', 'password1', 'general');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user25', 'user23@example.com', 'password2', 'moderator');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user36', 'user32@example.com', 'password3', 'admin');


INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('test244', 'user1441@example.com', 'password1', 'general');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user225', 'user223@example.com', 'password2', 'moderator');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user356', 'user312@example.com', 'password3', 'admin');

------------------------------------
-------TESTING CONSTRAINT: Admin
------------------------------------
--TASK: admin = 
-- should FAIL
-- should FAIL
-- should FAIL --WORKING
UPDATE USERS SET role = 'admin' WHERE id = 1; 
UPDATE USERS SET role = 'admin' WHERE id = 2; 
UPDATE USERS SET role = 'admin' WHERE id = 3; 
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('useradminFail', 'useraF@example.com', 'password3', 'admin');


------------------------------------
-------TESTING CONSTRAINT: Moderater
------------------------------------
--TASK: moderator = moderator, general
-- should SUCCEED
-- should SUCCEED
-- should FAIL
UPDATE USERS SET role = 'moderator' WHERE id = 1; 
UPDATE USERS SET role = 'moderator' WHERE id = 2; 
UPDATE USERS SET role = 'moderator' WHERE id = 3; 

------------------------------------
-------TESTING CONSTRAINT: General
------------------------------------

-- Try to update the roles of the sample USERS and see if the triggers work as expected
UPDATE USERS SET role = 'moderator' WHERE id = 1; 
-- Should fail since general USERS cannot be updated to the moderator role

UPDATE USERS SET role = 'admin' WHERE id = 1; 
-- Should fail since only admin USERS can be assigned to the admin role

UPDATE USERS SET role = 'general' WHERE id = 2; 
-- Should work since moderator USERS can only be assigned to the moderator or general role

UPDATE USERS SET role = 'admin' WHERE id = 2; 
-- Should fail since only admin USERS can be assigned to the admin role

UPDATE USERS SET role = 'moderator' WHERE id= 3; 
-- Should work since admin USERS can be updated to the moderator role 

UPDATE USERS SET role = 'admin' WHERE id = 3; 
-- Should fail since an admin user cannot be updated to the admin role



SELECT * from USERS;


DROP TABLE USERS;