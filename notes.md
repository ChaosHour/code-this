ansible-playbook playbooks/db_reseed-innobackupex.yml

```
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
dbtraining002          : ok=10   changed=4    unreachable=0    failed=0
dbtraining003          : ok=16   changed=12   unreachable=0    failed=0
```


```
ansible -u me dbtraining003 -e @vars/main.yml -m shell -s -a 'mysql -u root
-p"{{ mysql_root_pass }}" -e "show slave status\G"| egrep
"Slave_IO_Running:|Slave_SQL_Running:|Seconds_Behind_Master:|Master_Host:"'
dbtraining003 | SUCCESS | rc=0 >>
                  Master_Host: x.x.x.x
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
        Seconds_Behind_Master: 0

```
