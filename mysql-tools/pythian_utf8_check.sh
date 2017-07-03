#! /usr/bin/env bash
############################################################################################
#     ____        _   _     _               ____              ___
#    |  _ \ _   _| |_| |__ (_) __ _ _ __   |  _ \  _____   __/ _ \ _ __  ___
#    | |_) | | | | __| '_ \| |/ _` | '_ \  | | | |/ _ \ \ / / | | | '_ \/ __|
#    |  __/| |_| | |_| | | | | (_| | | | | | |_| |  __/\ V /| |_| | |_) \__ \
#    |_|    \__, |\__|_| |_|_|\__,_|_| |_| |____/ \___| \_/  \___/| .__/|___/
#           |___/                                                 |_|
#                       Script Created by: Kurt Larsen 
#                       Date: 6-30-2017
#                       Purpose of script: 
#                       To check if utf8 encoded data is being stored in  latin1 columns.
#                       The script makes use of nested bash loops.
#                       contributors: Jamie Roberts for the IFS=$'\n' part
#                       Apparently, I didn't rtfm. Thank's Jamie for your insight.
############################################################################################
# Un comment to debug bash script.
#set -xv
# Set your database var.
DB1="char_test_db"
# Get a list of tables to loop through. 
TB=$( mysql -Bse "show tables from ${DB1}" )

for i in ${TB}
do
   TB2=$( mysql -Bse "SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = '${i}' and table_schema = '${DB1}' ORDER BY ordinal_position" ${DB1})
# shell parses on newline now. Without this it parses on spaces.
IFS=$'\n'

   for j in ${TB2}
   do
     #echo "Current table is ${i} Column ${j}";
     QUERY="SELECT count(*)\`${j}\` FROM \`${DB1}\`.\`${i}\` WHERE LENGTH(\`${j}\`) != CHAR_LENGTH(\`${j}\`)" 
     COUNT=$(mysql -Bse ${QUERY})
      # echo out the tables and columns this script loops through for testing.
      #echo ${QUERY} 
      if [[ ${COUNT} -gt "0" ]]
      then
         echo "Current table => ${i} and Column =>  ${j}  has a count of ${COUNT} records that need to be fixed ";
      fi
   done
done
