Role Names
=========
- percona
- proxysql
- replication


`This playbook sets up 4 vms total. To test out ProxySQL read/write splitting, and failover. A Master with 2 slaves replicated.`


A brief description of the roles.
================================
- percona     role - Installs server, client, and setups dirs where the db will live.
- proxysql    role - Installs, setup, and configures proxysql to use for failover, and read, write splitting.
- replication role - Sets up MySQL replication between the slave, and etlslave with the master.  One master to slaves connected.


Requirements before you can use this playbook, and roles.
------------
16 Gigs of ram or more.

ansible --version
ansible 2.1.0.0

vagrant --version
Vagrant 1.8.1

virtualbox
5.0.24

```
*Note:* There is a problem with the error handling in the Ansible mysql_replication.py extras
module. 

In order to use the mysql_replication module, 
you have to change the way it works with MySQL passwords from a script, from the command line.


*/usr/local/Cellar/ansible/1.9.**4/libexec/lib/python2.7/site-*
*packages/ansible/modules/**extras/database/mysql/mysql_**replication.py*

320:        warnings.filterwarnings('ignore', category=MySQLdb.Warning)
321:        #warnings.filterwarnings('error', category=MySQLdb.Warning)

I had to use ignore instead of the original line 321 error.

Also, passwords are not encrytped on purpose, as this is used to help teach how to use them in your playbook.
When you want to encrypt your passwords, you can use ansible-vault create vars/main.yml your encrypted file.

```


Ansible dependancies are installed from the playbooks.  The ansible.cfg and host file are included.  Some changes may need to happen with the host file. To be able to use it with your environment.

The hosts file was built from the information provided by vagrant ssh-config

------------

Example Usage
----------------

cd to pythian-code-challenge; run vagrant status to make sure there are no issues with the Vagrantfile.  If that looks good then run vagrant up.

You should start to see your vm's being built. Soon after vagrant will pass the work to ansible to provision, and configure your boxes.


The directory structure, as it is now.

```tree
.
├── README.md
├── Vagrantfile
├── ansible.cfg
├── build.retry
├── build.yml
├── hosts
├── pythian-code-challenge-img
│   └── Screen\ Shot\ 2016-07-18\ at\ 3.18.07\ PM.png
├── roles
│   ├── percona
│   │   ├── files
│   │   │   ├── checkip-dyndns.sh
│   │   │   └── secure.sql
│   │   ├── tasks
│   │   │   ├── main.yml
│   │   │   ├── post-install.yml
│   │   │   └── pre-install.yml
│   │   └── templates
│   │       └── my.cnf.j2
│   ├── proxysql
│   │   ├── files
│   │   │   ├── proxysql-1.2.0-1-centos7.x86_64.rpm
│   │   │   └── rules.sql
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   └── replication
│       └── tasks
│           └── main.yml
└── vars
    └── main.yml

13 directories, 38 files
```


Troubleshooting:
If you find that after building your vms, and Ansible has deployed, provisioned without any issues, but you are not able to ping your vms via  ansible -u vagrant -i hosts all -m ping  then do check that you can ssh into them using the information from vagrant ssh-config.

Example:

ssh -i /Users/kurt.larsen/vagrant/pythian-code-challenge/.vagrant/machines/etlslave/virtualbox/private_key vagrant@127.0.0.1 -v -p2202

You may find that you have to delete an older entry in your vi +774 /Users/kurt.larsen/.ssh/known_hosts.  Then try it again.




License
-------

BSD

Author Information
------------------
Kurt Larsen  Las Vegas, NV
