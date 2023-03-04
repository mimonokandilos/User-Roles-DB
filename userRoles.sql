--https://www.mysqltutorial.org/mysql-triggers/mysql-drop-trigger/
--following syntax from here


-- Create a trigger that ensures USERS have a password when they are added or updated
-- WORKING
DELIMITER $$
CREATE TRIGGER user_password_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.password = '' OR NEW.password IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User must have a password';
    END IF;
END $$
DELIMITER ;

CREATE TRIGGER user_password_check BEFORE INSERT ON USERS
FOR EACH ROW
BEGIN
    IF NEW.password = '' OR NEW.password IS NULL THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'User must have a password';
    END IF;
END 



--NOT SURE ABOUT SYNTAX
-- Create a trigger that ensures only admin USERS can be updated to an admin role
-- WORKINNG
DELIMITER $$
CREATE TRIGGER admin_role_check BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'admin' AND OLD.role != 'admin' AND NEW.role != OLD.role AND OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only admin users can be assigned to the admin role';
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER admin_role_check BEFORE UPDATE ON USERS
FOR EACH ROW
BEGIN
    IF NEW.role = 'admin' AND OLD.role != 'admin' AND NEW.role != OLD.role AND OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Only admin USERS can be assigned to the admin role';
    END IF;
END $$
DELIMITER ;

-- Create a trigger table=USERS, that ensures moderator USERS can only be created moderator or general role
--Create a trigger that ensures moderator USERS can only be updated to a  moderator or general role only if approved by admin
--notWORKINNG
-- 
---needs a clause about 
CREATE TRIGGER admin_role_check 
    BEFORE UPDATE ON USERS
    FOR EACH ROW 
 INSERT INTO employees_audit
 SET action = 'update',
     employeeNumber = OLD.employeeNumber,
     lastname = OLD.lastname,
     changedat = NOW();
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='UPDATE REQUESTS NEEDS TO BE AUDITED'



DELIMITER $$
CREATE TRIGGER moderator_role_check BEFORE UPDATE ON USERS
FOR EACH ROW
BEGIN
    IF NEW.role = 'moderator' AND OLD.role != 'admin' AND NEW.role != OLD.role AND OLD.role != 'moderator' AND OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator USERS can only be assigned to the moderator or general role';
    END IF;
END $$
DELIMITER ;

-- Create a trigger that ensures general USERS can only be updated to a general role
--notWORKINNG
DELIMITER $$
CREATE TRIGGER general_role_check BEFORE UPDATE ON USERS
FOR EACH ROW
BEGIN
    IF NEW.role = 'general' AND OLD.role != 'admin' AND NEW.role != OLD.role AND OLD.role != 'moderator' AND OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'General USERS can only be assigned to the general role';
    END IF;
END $$
DELIMITER ;


-- Create a trigger table=USERS, that ensures moderator USERS can only be created moderator or general role
-- Create a trigger that ensures moderator USERS can only be updated to a  moderator or general role only if approved by admin
--notWORKINNG

-- CREATE TRIGGER moderator_role_update_trigger
-- BEFORE UPDATE ON users
-- FOR EACH ROW
-- BEGIN
--   IF NEW.role IN ('admin', 'general') AND OLD.role = 'moderator' AND NEW.approved_by_admin = 0 THEN
--     SIGNAL SQLSTATE '45000' 
--     SET MESSAGE_TEXT = 'Cannot update moderator role without admin approval';
--   END IF;
-- END;