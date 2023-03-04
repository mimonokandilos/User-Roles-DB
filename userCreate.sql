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
SELECT * FROM AUDIT_HISTORY;

SHOW TRIGGERS;
