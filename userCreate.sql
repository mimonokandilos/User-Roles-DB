-- Create DB, TABLES to store user information
--might need append audit history with user created /updated
DROP DATABASE FIETO; CREATE DATABASE IF NOT EXISTS FIETO;

CREATE TABLE FIETO.USERS (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role ENUM('public', 'general', 'moderator', 'admin') NOT NULL DEFAULT 'public'
);

CREATE TABLE FIETO.AUDIT_HISTORY (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  action VARCHAR(255),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE FIETO.PEMISSION_HISTORY (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  action VARCHAR(255),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  admin_consent TINYINT(1) NOT NULL DEFAULT 0
);

INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('userpublic', 'userPublic@example.com', 'password3', 'public');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user1', 'user1@example.com', 'password1', 'general');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user2', 'user2@example.com', 'password2', 'moderator');
INSERT INTO FIETO.USERS (username, email, password, role) VALUES ('user3', 'user3@example.com', 'password3', 'admin');



use FIETO;
SELECT * FROM USERS;
SELECT * FROM AUDIT_HISTORY;
SELECT * FROM PERMISSIONS_HISTORY;

SHOW TRIGGERS;
