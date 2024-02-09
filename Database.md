`mysqld.cnf`:
- User should always be called `mysql`
- Bind address by default is localhost, but needs to be 0.0.0.0 to bind it to ip address of the machine
- Port should be 3306/tcp

Setup is actually really easy: (if quotes don't work try backticks)
```sh
sudo apt install mysql-server -y
sudo mysql_secure_installation
# medium password should be fine, no anonymous users, disable remote root login, remove test database, reload permissions
sudo systemctl status mysql # start, enable, etc

sudo mysql -u root # gets you into the system as root user
```

Once you're in the database:
```mysql
CREATE USER 'blueteam'@'%' IDENTIFIED BY '<password>';
# % is a wildcard char, your password must meet requirements
# backdoor user should be localhost
GRANT CREATE, INSERT, UPDATE, DELETE, SELECT on <database>.<table> TO '<username>'@'%';
FLUSH PRIVILEGES;
```

Users:
```
+-------------+--------+
| User        | Host   |
+-------------+--------+
| custom      | %      |

```

```mysql

SHOW GRANTS FOR 'username'@'%';

#### Revoking permissions
REVOKE DROP ON <database>.<table> FROM '<username>'@'%';

#### Altering
ALTER USER '<username>'@'<hostname>' IDENTIFIED WITH mysql_native_password BY '<password>'
# that's theoretically how you change your password
```

You also will need to change some firewall rules:
```sh
sudo ufw allow mysql
sudo ufw allow ssh
sudo ufw enable
sudo ufw status
# make sure the bind address is changed
```

```sh
mysql -u <username> -h <ipaddr> -p
#it will then prompt for password
```

Creating your database:
```sh
sudo mysql -u root -p
 > CREATE DATABASE betterblog;
 > exit
sudo mysql -u root -p betterblog < database.sql
sudo mysql -u root -p
 > USE betterblog;
 > SHOW TABLES;
```