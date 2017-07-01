Bash script to check UTF8 Encodings in Latin1 

What is needed: 
- Bash 
- SQL file to create a database and table for testing.
- pythian_utf8_check.sh script 
- testdb.sql

```
*Note:* 
cat testdb.sql | mysql

Run the script to validate your data from the char_test_db

Results:
MacBook-Pro:mysql-tools klarsen$ ./pythian_utf8_check.sh
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
