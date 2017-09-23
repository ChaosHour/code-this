####
USE mysql;
#DROP DATABASE IF EXISTS test;
#DELETE FROM mysql.db where Db='test' OR Db='test\\_%';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE User='';
DELETE FROM mysql.user WHERE host != 'localhost';


FLUSH PRIVILEGES;
