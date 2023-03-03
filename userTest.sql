--------TESTING--------
-- Create DB, TABLES to store user information
DROP DATABASE FIETO; CREATE DATABASE IF NOT EXISTS FIETO;

CREATE TABLE FIETO.USERS (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    role ENUM('general', 'moderator', 'admin') NOT NULL DEFAULT 'general'
);

CREATE TABLE FIETO.EMPLOYEES_AUDIT (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

--Code language: SQL (Structured Query Language) (sql)


--Create table to have audit informations
CREATE TABLE FIETO.AUDIT_HISTORY ()

--test data quick insert for each role
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user1', 'user1@example.com', 'password1', 'general');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user2', 'user2@example.com', 'password2', 'moderator');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user3', 'user3@example.com', 'password3', 'admin');

------------------------------------
------STOP HERE---------------------
--have you enabled constraints?-----
-----pax tibi marce-----------------
--IF YES, Begin Testing Sequenc
------------------------------------

---
use FIETO;
SELECT * FROM USERS;
SHOW TRIGGERS;
-- mysql> select * from users;
-- +----+----------+-------------------+-----------+-----------+
-- | id | username | email             | password  | role      |
-- +----+----------+-------------------+-----------+-----------+
-- |  1 | user1    | user1@example.com | password1 | general   |
-- |  2 | user2    | user2@example.com | password2 | moderator |
-- |  3 | user3    | user3@example.com | password3 | admin     |
-- +----+----------+-------------------+-----------+-----------+
-- 3 rows in set (0.00 sec)

--
SHOW TRIGGERS;
--whout password WORKING
INSERT INTO USERS (username, email, password, role) VALUES ('user4', 'user4@example.com', '', 'general');
---ERROR 1644 (45000): User must have a password


------------------------------------
-------TESTING CONSTRAINT: Admin
------------------------------------
--TASK: admin = 
-- should FAIL
-- should FAIL
-- should SUCCEED
UPDATE USERS SET role = 'admin' WHERE id = 1; 
UPDATE USERS SET role = 'admin' WHERE id = 2; 
UPDATE USERS SET role = 'admin' WHERE id = 3; 


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