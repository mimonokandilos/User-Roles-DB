--https://www.mysqltutorial.org/mysql-triggers/mysql-drop-trigger/
--following syntax from here


-- Create a trigger that ensures USERS have a password when they are added or updated
-- WORKING
--PASSSWORD TRIGGER
DELIMITER $$
CREATE TRIGGER user_password_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.password = '' OR NEW.password IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User must have a password';
    END IF;
END $$
DELIMITER ;


--AUDIT HISTORY TRIGGER
--USER ADD or UPDATE IS NOW GOINg to trigger a audit history table
DELIMITER $$
CREATE TRIGGER audit_user_update AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_history (user_id, action)
    VALUES (OLD.id, CONCAT('Updated user with ID ', OLD.id));
END $$
DELIMITER ;



DELIMITER $$
CREATE TRIGGER audit_user_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_history (user_id, action)
    VALUES (NEW.id, CONCAT('Updated user with ID ', NEW.id));
END $$
DELIMITER ;

--ADMIN ROLE CHECK
-- WORKINNG BOTH TRIGGERS
-- Create a trigger that doesnt allow any role to be updated to admin


DELIMITER $$
CREATE TRIGGER admin_role_check BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'admin' OR  NEW.role != OLD.role OR OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only admin users can be assigned to the admin role';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER prevent_admin_accounts BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'admin' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Creating an admin account is not allowed';
    END IF;
END $$
DELIMITER ;


--- TRIGGER that creates an update to an audit_history table
---trigger to update the audit history on an insert


-- Create a trigger table=USERS, that ensures moderator USERS can only be created moderator or general role
--Create a trigger that ensures moderator USERS can only be updated to a  moderator or general role only if approved by admin
--notWORKINNG
-- MODERATOR
---needs a clause about 
--not working
DELIMITER $$
CREATE TRIGGER moderator_role_check BEFORE UPDATE ON USERS
FOR EACH ROW
BEGIN
    IF  NEW.role != OLD.role OR OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator USERS can only be assigned to the moderator or general role';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER moderator_role_insert_check BEFORE INSERT ON USERS
FOR EACH ROW
BEGIN
    IF NEW.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator USERS can only be assigned to the moderator or general role';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER moderator_role_check BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'moderator' OR OLD.role = 'moderator' OR NEW.role != OLD.role THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update an existing moderator account';
    ELSEIF NEW.role = 'moderator' AND OLD.role != 'moderator' AND NEW.role != OLD.role AND OLD.role != '' THEN
        INSERT INTO audit_history (user_id, action)
        VALUES (NEW.id, CONCAT('Updated user with ID ', NEW.id, ' to be a moderator'));
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