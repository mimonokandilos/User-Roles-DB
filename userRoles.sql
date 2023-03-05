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


-- Create a trigger table=USERS, that ensures moderator USERS can only be created moderator or general role
--Create a trigger that ensures moderator USERS can only be updated to a  moderator or general role only if approved by admin
--notWORKINNG
-- MODERATOR

--CREATE
--moderatros --> admin : fail works
--moderatros --> moderators : fail  not working
--moderatros --> general : succeed  not works
--moderator --> public : succeed not works
--UPDATE
--moderatros --> admin : fail works
--moderatros --> moderators : fail  not working
--moderatros --> general -> public 
--moderator --> public -> general


DELIMITER $$
CREATE TRIGGER moderator_role_insert_check BEFORE INSERT ON USERS
FOR EACH ROW
BEGIN
    IF NEW.role = 'moderator' OR NEW.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator USERS can only create  to the moderator or general role';
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER moderator_role_insert_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'moderator' AND NEW.admin_consent = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator USERS can only create to the moderator or general role with admin consent';
    END IF;
END $$
DELIMITER ;

--In this example, the admin_consent column is set to 0 by default and will need to be manually updated to 
--1 by an admin user for the trigger to allow the creation of a new moderator or admin account. 
--This can be done using a separate application or script outside of the database.


CREATE TRIGGER moderator_role_insert_check  moderator
    check if Pemissionhistory table contains record of that user_id and action that is tyrying to bve inserted
        if entry is found check if there is admin consent granted in the columnadmin consent is ganted in the CREATE TABLE FIETO.PEMISSIions(admin_consent
            if 1 then allow INSERT
            if 0 then 
                insert into the permissions history table
        else 
            throw sql error you need admin consent
    else
        insert into the permissions history table


--trigger wont work we need to fix the seledct statement to run only after a check has been inserted somehow???
DELIMITER $$
CREATE TRIGGER moderator_role_insert_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE permission_count INT;
    IF SELECT COUNT(*) INTO permission_count FROM permission_history WHERE user_id = NEW.id AND action = 'create_general';
        IF NEW.role = 'moderator' THEN
            IF permission_count > 0 THEN
                SELECT admin_consent INTO @admin_consent FROM permission_history WHERE user_id = NEW.id AND action = 'create' LIMIT 1;
                IF @admin_consent = 1 THEN
                ELSE
                    INSERT INTO permission_history (user_id, action) VALUES (NEW.id, 'create');
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator users can only create accounts with moderator or general role with admin consent';
                END IF;
            ELSE
                INSERT INTO permission_history (user_id, action) VALUES (NEW.id, 'create');
            END IF;
        ELSE
            INSERT INTO permission_history (user_id, action) VALUES (NEW.id, 'create');
        END IF;
    ELSE
        INSERT INTO permission_history (user_id, action) VALUES (NEW.id, 'create');
    END IF;
END $$
DELIMITER ;








DELIMITER $$
CREATE TRIGGER moderator_role_insert_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'moderator' AND NEW.role != OLD.role THEN
        INSERT INTO permission_history (user_id, action, admin_consent)
        VALUES (NEW.id, CONCAT('Created user with ID ', NEW.id, ' as a general user with admin consent'), 1);
    ELSEIF NEW.role = 'general' AND NEW.role != OLD.role THEN
        INSERT INTO permission_history (user_id, action, admin_consent)
        VALUES (NEW.id, CONCAT('Created user with ID ', NEW.id, ' as a general user with admin consent'), 1);
    ELSEIF NEW.role != 'general' AND NEW.role != 'moderator' AND NEW.role != OLD.role AND OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator USERS can only create general or moderator accounts with admin consent';
    END IF;
END $$
DELIMITER ;


--
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

DELIMITER $$
CREATE TRIGGER moderator_role_check BEFORE UPDATE ON USERS
FOR EACH ROW
BEGIN
    IF  NEW.role != OLD.role OR OLD.role != '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator USERS can only be assigned to the moderator or general role';
    END IF;
END $$
DELIMITER ;


-- Create a trigger that ensures general USERS can only be updated to a general role
--notWORKINNG
DELIMITER $$
CREATE TRIGGER moderator_role_insert_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE permission_count INT;
    SELECT COUNT(*) INTO permission_count FROM permission_history WHERE user_id = NEW.id AND action = 'create_general';
    IF permission_count > 0 THEN
        IF NEW.role = 'moderator' THEN
            SELECT admin_consent INTO @admin_consent FROM permission_history WHERE user_id = NEW.id AND action = 'create_general' LIMIT 1;
            IF @admin_consent = 1 THEN
                -- Allow insert
            ELSE
                INSERT INTO permission_history (user_id, action) VALUES (NEW.id, 'create_general');
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Moderator users can only create accounts with moderator or general role with admin consent';
            END IF;
        ELSE
            -- Allow insert
        END IF;
    ELSE
        INSERT INTO permission_history (user_id, action) VALUES (NEW.id, 'create_general');
    END IF;
END $$
DELIMITER ;
