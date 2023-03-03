
-- Create table to store user information
CREATE TABLE users (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role ENUM('general', 'moderator', 'admin') NOT NULL DEFAULT 'general'
);

-- Create a trigger that ensures users have a password when they are added or updated
DELIMITER $$
CREATE TRIGGER user_password_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.password = '' OR NEW.password IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User must have a password';
    END IF;
END $$
DELIMITER ;

-- Create a trigger that ensures only admin users can be updated to an admin role
DELIMITER $$
CREATE TRIGGER admin_role_check BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'admin' AND OLD.role != 'admin' AND NEW.role != OLD.role AND OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only admin users can be assigned to the admin role';
    END IF;
END $$
DELIMITER ;

-- Create a trigger that ensures moderator users can only be updated to a moderator or general role
DELIMITER $$
CREATE TRIGGER moderator_role_check BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'moderator' AND OLD.role != 'admin' AND NEW.role != OLD.role AND OLD.role != 'moderator' AND OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator users can only be assigned to the moderator or general role';
    END IF;
END $$
DELIMITER ;

-- Create a trigger that ensures general users can only be updated to a general role
DELIMITER $$
CREATE TRIGGER general_role_check BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'general' AND OLD.role != 'admin' AND NEW.role != OLD.role AND OLD.role != 'moderator' AND OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'General users can only be assigned to the general role';
    END IF;
END $$
DELIMITER ;

-- Test the triggers by adding some sample data
INSERT INTO users (username, email, password, role) VALUES ('user1', 'user1@example.com', 'password1', 'general');
INSERT INTO users (username, email, password, role) VALUES ('user2', 'user2@example.com', 'password2', 'moderator');
INSERT INTO users (username, email, password, role) VALUES ('user3', 'user3@example.com', 'password3', 'admin');

-- Try to update the roles of the sample users and see if the triggers work as expected
UPDATE users SET role = 'moderator' WHERE id = 1; -- Should work since general users can be updated to the moderator role
UPDATE users SET role = 'admin' WHERE id = 1; -- Should fail since only admin users can be assigned to the admin role
UPDATE users SET role = 'general' WHERE id = 2; -- Should fail since moderator users can only be assigned to the moderator or general role
UPDATE users SET role = 'admin' WHERE id = 2; -- Should fail since only admin users can be assigned to the admin role
UPDATE users SET role = 'moderator' WHERE id= 3; -- Should work since admin users can be updated to the moderator role
UPDATE users SET role = 'admin' WHERE id = 3; -- Should fail since an admin user cannot be updated to the admin role