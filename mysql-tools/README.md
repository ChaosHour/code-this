Bash script to check UTF8 Encodings 

What is needed: 
- Bash 
- SQL file to create a database and table for testing.
- testdb.sql
- pythian_utf8_check.sh script 
- Currently the use of a ~/.my.cnf to hold your MySQL creds.
```
*Note:* 
> [The Database schema and Table structure used for testing provided from here!](https://oracle-base.com/articles/mysql/mysql-converting-table-character-sets-from-latin1-to-utf8)

cat testdb.sql | mysql

Now mangle the data for testing.
SET NAMES utf8;

ALTER TABLE t1 CONVERT TO CHARACTER SET utf8;

SELECT id, description, HEX(description) FROM t1;
+----+----------------+------------------------------+
| id | description    | HEX(description)             |
+----+----------------+------------------------------+
|  1 | Â¡VolcÃ¡n!     | C382C2A1566F6C63C383C2A16E21 |
+----+----------------+------------------------------+
1 row in set (0.01 sec)

mysql>

Run the script to validate your data from the char_test_db

Results:
./pythian_utf8_check.sh
Current table => t1 and Column =>  description  has a count of 1 records that need to be fixed
```
```
mysql -e "show table status like 't1'\G" char_test_db
*************************** 1. row ***************************
           Name: t1
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 0
 Avg_row_length: 0
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 2
    Create_time: 2017-06-30 22:32:59
    Update_time: 2017-06-30 22:32:59
     Check_time: NULL
      Collation: utf8_general_ci
       Checksum: NULL
 Create_options:
        Comment:
```
