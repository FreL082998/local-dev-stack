-- DROP USER 'xampp'@'%';
CREATE USER 'xampp'@'%' IDENTIFIED WITH mysql_native_password BY 'Abc@12345';
ALTER USER 'xampp'@'%' IDENTIFIED WITH mysql_native_password BY 'Abc@12345';
GRANT ALL PRIVILEGES ON *.* TO 'xampp'@'%';
FLUSH PRIVILEGES;