-- DROP USER 'developer'@'%';
CREATE USER 'developer'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
ALTER USER 'developer'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'developer'@'%';
FLUSH PRIVILEGES;