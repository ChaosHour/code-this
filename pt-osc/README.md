#PT-OSC
Percona Replication with GTIDs - VM

This is an Ansible Playbook to bootstrap, setup, and configure a 3 node Percona-Gtid Replicated Environment for testing.



Role Name
=========
- gtids
- replication


A brief description of the roles.
================================
Percona Replication Using GTIDs - The gtids role - Installs server, client, and setups dirs where the db will live.
The replication role - Setups replication using GTIDs - Slave, and etl, to Master.

VM's Used to test PT-OSC.

Requirements before you can use this playbook, and roles.
------------
https://www.vagrantup.com/downloads.html

Vagrant Plugins:
  - vagrant plugin install vagrant-vbguest
  - vagrant plugin install vagrant-hostmanager

List your Vagrant Plugins:
  - vagrant plugin  list

https://www.virtualbox.org/wiki/Downloads
  - Make sure to download the Extension Pack.

https://git-scm.com/download/mac
 - Git 4 Mac:

 vagrant box update  
 To update CentOS 7 to the latest used by Vagrant.

 Internet Access
 16 Gigs of ram or more.
---

 Docker is used to spin up a Redis container for the backend caching with Ansible.
 If you don't want to use it? Comment it out from the ansible.cfg file.
 You will need this to be running before (vagrant up).

```
Redis:
Remove container:
docker rm -v $(docker ps -aq --filter=ancestor=redis:latest)

Spin up conatiner:
docker run --name redis -d -p 6379:6379 redis:latest

The 'redis' python module is required for the redis fact cache, 'pip install redis'

Check that the container is running:
docker ps
```

`The hosts file can be changed as well. I use loopback IP and ports from vagrant ssh-config`

```
You can change the hosts file to use the IP's from the Vagrantfile per host.  The vangrant host-manager will update you local Mac /etc/hosts file and that of each VM.


Ansible-Vault is used to encrypt the vars main.yml file.  This is set to decrypt in the Vagrantfile. Just wanted to show some usage with Ansible-Vault.

Note:
Make sure that the vault_pass.txt file is set with chmod 644. Other wise ansible will think it is a script and not continue.



Ansible dependancies are installed from the playbooks.  The ansible.cfg and host file are included.  Some changes will need happen with the these files. To be able to use it with your environment.

The hosts file was built from the information provided by vagrant ssh-config
```

#Look for the CHANGE-ME in them, an adjust accordingly.
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
percona-gtids$ ansible -u vagrant -i inventory slave:etl -e @vars/main.yml -m shell -b -a 'mysql -u root -p"{{ mysql_root_pass }}" -e "show slave status\G"| egrep "Slave_IO_Running:|Slave_SQL_Running:|Seconds_Behind_Master:|Master_Host:"' --vault-password-file vars/vault_pass.txt
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



```
Ping your hosts:

ansible -i inventory all -l master  -m ping
master | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}

ansible -i inventory all -l master:slave -m ping
slave | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}
master | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}

ansible -i inventory all  -m ping
master | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}
slave | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}
etl | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}
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
