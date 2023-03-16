### Mike Monokandilos
#
# User Scheduling Database

### DESCRIPTION
- This is a database implementation of a security group with user roles (public, general, moderator, admin)

### MYSQL SERVER INSTALLATION

# for Ubunntu/fedora/
- dnf install mysql
- yum install mysql
- apt install mysql

- mysql_sercure_installation
    - set root password, plus securly install mysql

Check Mysql status
- systemctl status mysql(d)

Restart mysql
- systemctl restart mysql(d)

Start myql
- systemctl start mysql(d)


# for Mac
- brew install mysql

- mysql_sercure_installation
   - set root password, plus securly install mysql

Check Mysql status
- mysql.server status

Restart mysql
- mysql.server restart

Start myql
- mysql.server start

<br>


### TODO
--https://www.mysqltutorial.org/mysql-triggers/mysql-drop-trigger/
--following syntax from here

create another table FOR EMPLOYEES AUDIT that needs a outside signiture which will be allow ROOT user an update one time (then complete the request ONE time


### TESTING

The database was tested using the following classes and requirements:

In this example, we created a table to store user information, with columns for `id`, `username`, `email`, `password`, and `role`. We then created four triggers: 

- `user_password_check`: a `BEFORE INSERT` trigger that checks if a user has a password before they are added to the database. If a user does not have a password, the trigger signals an error with the message "User must have a password".
- `admin_role_check`: a `BEFORE UPDATE` trigger that checks if a user is being updated to the admin role. If the user is not currently an admin user, the new role is different from the old role, and the old role is not empty, the trigger signals an error with the message "Only admin users can be assigned to the admin role".
- `moderator_role_check`: a `BEFORE UPDATE` trigger that checks if a user is being updated to the moderator role. If the user is not currently an admin user, the new role is different from the old role, the old role is not moderator, and the old role is not empty, the trigger signals an error with the message "Moderator users can only be assigned to the moderator or general role".
- `general_role_check`: a `BEFORE UPDATE` trigger that checks if a user is being updated to the general role. If the user is not currently an admin user, the new role is different from the old role, the old role is not moderator, the old role is not admin, and the old role is not empty, the trigger signals an error with the message "General users can only be assigned to the general role".

We then added some sample data to the `users` table and tested the triggers by updating the roles of the sample users. The comments next to each update statement indicate whether the update should succeed or fail based on the role requirements and the expected trigger behavior.

These triggers can help maintain user roles and their requirements in a MySQL database, ensuring that users are assigned the correct role and preventing unauthorized changes to user roles.


With these triggers, you can ensure that:

Users must have a password when they are added or updated
Only admin users can be updated to an admin role
Moderator users can only be updated to a moderator or general role
General users can only be updated to a general role
You can modify these triggers to suit your specific needs and requirements for user roles in your MySQL database.
