-- init-db.sql
CREATE DATABASE IF NOT EXISTS eqdkp;

CREATE USER IF NOT EXISTS 'eqdkpuser'@'%' IDENTIFIED BY 'eqdkppassword';
GRANT ALL PRIVILEGES ON eqdkp.* TO 'eqdkpuser'@'%';
FLUSH PRIVILEGES;
