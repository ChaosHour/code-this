dbtraining002 is the master and dbtraining003 is the slave in this Ansible Playbook.

What is needed: 
- You have both servers in your ansible hosts file.
- You have tested your connections to both servers with ansible. 
- MySQL setup and running, as this is just a reseed playbook.
- A var yml file to store your passwords. example:  mysql_repl_pass and mysql_root_pass.

Directory layout:
Example:

playbooks
    |
     vars
             --> main.yml file



run usage:

- Validate your hosts first:

ansible-playbook playbooks/db_reseed-innobackupex.yml --list-hosts

This will also let you know, if any spacing or syntax options ansible does not like. It's main function is to list the affected hosts.

- When comfortable with the playbook run it:

ansible-playbook playbooks/db_reseed-innobackupex.yml

I like to log into both servers to monitor the progress, as well.

- On the Master

while :; do ps -ef grep -i ansible | grep -v grep; sleep 3; done

- On the Slave:

while :; do ls -lhrt /db/backup/* ; sleep 3; done

Just so I can see the backup is in progress of transfering.
This playbook worked, but more testing is needed.  Largest database size tested 2G; not that big. This was just a proof of concept for me.


Output from playbook:


ansible-playbook playbooks/db_reseed-innobackupex.yml

PLAY
***************************************************************************

TASK [setup]
*******************************************************************
ok: [dbtraining002]

TASK [Stop MySQL on the Slave]
*************************************************
ok: [dbtraining002 -> None]

TASK [Delete data in data01 logs01]
********************************************
changed: [dbtraining002 -> None]
 [WARNING]: Consider using file module with state=absent rather than
running rm


TASK [wait for ibdata01 to be deleted]
*****************************************
ok: [dbtraining002 -> None]

TASK [Clean any failed screen sessions on the slave]
***************************
...ignoring

TASK [Clean any failed screen sessions on the Master]
**************************
...ignoring

TASK [start listener on slave]
*************************************************
changed: [dbtraining002 -> None]

TASK [start transfer on master]
************************************************
changed: [dbtraining002]

TASK [Get pid of screen session on the Master]
*********************************
changed: [dbtraining002]

TASK [Wait for screen session on Master to complete]
***************************
ok: [dbtraining002]

PLAY
***************************************************************************

TASK [setup]
*******************************************************************
ok: [dbtraining003]

TASK [extract the xbstream files]
**********************************************
changed: [dbtraining003]

TASK [extract qpress files]
****************************************************
changed: [dbtraining003]

TASK [apply logs]
**************************************************************
changed: [dbtraining003]

TASK [move logs to /db/logs01]
*************************************************
changed: [dbtraining003]

TASK [Change owner ship to mysql of directories under /db]
*********************
changed: [dbtraining003]

TASK [change owner ship to mysql of files under /db]
***************************
changed: [dbtraining003]

TASK [Remove auto.cnf from /db/data01 dir on Slave]
****************************
ok: [dbtraining003]

TASK [Start MySQL on the Slave]
************************************************
changed: [dbtraining003]

TASK [cat xtrabackup_binlog file]
**********************************************
changed: [dbtraining003]

TASK [debug]
*******************************************************************
ok: [dbtraining003] => {
    "xtra1_file.stdout": "mysql-bin.000027"
}

TASK [cat xtrabackup_binlog2 file]
*********************************************
changed: [dbtraining003]

TASK [debug]
*******************************************************************
ok: [dbtraining003] => {
    "xtra2_file.stdout": "539258660"
}

TASK [Stop Replication]
********************************************************
changed: [dbtraining003]

TASK [Change master to start replication on Slave]
*****************************
changed: [dbtraining003]

TASK [Start Replication on Slave]
**********************************************
changed: [dbtraining003]

PLAY RECAP
*********************************************************************
- dbtraining002          : ok=10   changed=4    unreachable=0    failed=0
- dbtraining003          : ok=16   changed=12   unreachable=0    failed=0



Check your replication status:
-
- ansible -u me dbtraining003 -e @vars/main.yml -m shell -s -a 'mysql -u root
-p"{{ mysql_root_pass }}" -e "show slave status\G"| egrep
"Slave_IO_Running:|Slave_SQL_Running:|Seconds_Behind_Master:|Master_Host:"'
- dbtraining003 | SUCCESS | rc=0 >>
                  Master_Host: x.x.x.x
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
        Seconds_Behind_Master: 0

-
