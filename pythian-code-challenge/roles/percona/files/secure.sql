####
USE mysql;
#DROP DATABASE IF EXISTS test;
#DELETE FROM mysql.db where Db='test' OR Db='test\\_%';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE User='';
DELETE FROM mysql.user WHERE host != 'localhost';

#add the ProxySQL user
GRANT USAGE ON *.* TO 'proxy'@'192.%' IDENTIFIED BY 'proxy';
GRANT ALL ON test.* TO 'chaos'@'192.%' IDENTIFIED BY 'letmein';
GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost' IDENTIFIED BY 's3cret';
#GRANT ALL ON test.* TO 'chaos'@'127.0.0.1' IDENTIFIED BY 'letmein';
GRANT ALL ON *.* TO 'root'@'192.%' IDENTIFIED BY 'letmein' WITH GRANT OPTION;
GRANT REPLICATION CLIENT ON *.* TO 'monuser'@'192.%' IDENTIFIED BY 'monpass';

### Demo Root Password
UPDATE user SET Password='*CC44899BBE450A06A0823407493390266377825C' WHERE User='root';

FLUSH PRIVILEGES;
