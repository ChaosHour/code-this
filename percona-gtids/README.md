Percona Replication with GTIDs - VM

This is an Ansible Playbook to bootstrap, setup, and configure a 3 node Percona-Gtid Replicated Environment for testing.



Role Name
=========
gtids
replication


A brief description of the roles.
================================
Percona Replication Using GTIDs - The gtids role - Installs server, client, and setups dirs where the db will live.
The replication role - Setups replication using GTIDs - Slave, and etl, to Master.


Requirements before you can use this playbook, and roles.
------------
Internet Access
16 Gigs of ram or more.

ansible --version
ansible 2.1.0.0

vagrant --version
Vagrant 1.8.1

virtualbox
5.0.24


Ansible-Vault is used to encrypt the vars main.yml file.  This is set to decrypt in the Vagrantfile. Just wanted to show some usage with Ansible-Vault.



Ansible dependancies are installed from the playbooks.  The ansible.cfg and host file are included.  Some changes will need happen with the these files. To be able to use it with your environment.


`Look for the CHANGE-ME in them, an adjust accordingly.`


The hosts file was built from the information provided by vagrant ssh-config

----------------
Example Usage
----------------

cd to percona-gtids; run vagrant status to make sure there are no issues with the Vagrantfile.  If that looks good then run vagrant up.

You should start to see your vm's being built. Soon after vagrant will pass the work to ansible to provision, and configure your boxes.


The directory structure, as it is now.
```
tree
.
├── ansible.cfg
├── build.yml
├── hosts
├── README.md
├── roles
│   ├── gtids
│   │   ├── files
│   │   │   └── secure.sql
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   ├── main.yml
│   │   │   ├── post-install.yml
│   │   │   ├── pre-install.yml
│   │   │   └── usermaint.yml
│   │   └── templates
|   |       |__ .my.cnf.j2
│   │       └── my.cnf-gtids.j2
│   └── replication
│       └── tasks
│           └── main.yml
├── Vagrantfile
└── vars
    ├── main.yml
    └── vault_pass.txt

9 directories, 16 files
```


`The replication playbook towards the end will display the replicated state.`

```
TASK [replication : debug] *****************************************************
ok: [etl] => {
    "(repl_stat2.Master_Host,repl_stat2.Slave_IO_Running,repl_stat2.Slave_SQL_Running,repl_stat2.Executed_Gtid_Set)": "(u'192.168.50.2', u'Yes', u'Yes', u'17384a4b-65ad-11e6-a9de-525400c3c0db:1-16')"
}

```


`You can use Ansible to check replication after the playbook has completed.`

```
percona-gtids$ ansible -u vagrant slave:etl -e @vars/main.yml -m shell -s -a 'mysql -u root -p"{{ mysql_root_pass }}" -e "show slave status\G"| egrep "Slave_IO_Running:|Slave_SQL_Running:|Seconds_Behind_Master:|Master_Host:"' --vault-password-file vars/vault_pass.txt
slave | SUCCESS | rc=0 >>
                  Master_Host: 192.168.50.2
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
        Seconds_Behind_Master: 0Warning: Using a password on the command line interface can be insecure.

etl | SUCCESS | rc=0 >>
                  Master_Host: 192.168.50.2
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
        Seconds_Behind_Master: 0Warning: Using a password on the command line interface can be insecure.

```

Troubleshooting:
If you find that after building your vms, and Ansible has deployed, provisioned without any issues, but you are not able to ping your vms via  ansible -u vagrant -i hosts all -m ping  then do check that you can ssh into them using the information from vagrant ssh-config.

Example:
Do check your your ports and settings with vagrant ssh-config first to validate them.

ssh -i /Users/kurt.larsen/vagrant/pythian-code-challenge/.vagrant/machines/etlslave/virtualbox/private_key vagrant@127.0.0.1 -v -p2202

You may find that you have to delete an older entry in your vi +774 /Users/kurt.larsen/.ssh/known_hosts.  Then try it again.




License
-------

BSD

Author Information
------------------
Kurt Larsen  Las Vegas, NV
