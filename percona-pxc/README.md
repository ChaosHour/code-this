Percona Cluster - VM

This is an Ansible Playbook to bootstrap, setup, and configure a 3 node Percona-PXC cluster for testing.



Role Name
=========
pxc



A brief description of the roles.
================================
Percona Cluster - The pxc role - Installs server, client, and setups dirs where the db will live.



Requirements before you can use this playbook, and roles.
------------
- Internet Access
- 16 Gigs of ram or more.

- ansible --version
- ansible 2.1.0.0

- vagrant --version
- Vagrant 1.8.1

- virtualbox
  5.0.24

`
Ansible dependancies are installed from the playbooks.
The ansible.cfg and host file are included.  Some changes will need to happen with them. Areas marked CHANGE-ME are noted in the files.
The hosts file was built from the information provided by vagrant ssh-config
`

----------------
Example Usage
----------------

cd to percona-pxc; run vagrant status to make sure there are no issues with the Vagrantfile.  If that looks good then run vagrant up.

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
│   └── pxc
│       ├── files
│       │   └── secure.sql
│       ├── handlers
│       │   └── main.yml
│       ├── tasks
│       │   ├── main.yml
│       │   ├── post-install.yml
│       │   ├── pre-install.yml
│       │   └── usermaint.yml
│       └── templates  
│           ├── .my.cnf.j2
│           └──  my.cnf-pxc.j2
├── Vagrantfile
└── vars
    ├── main.yml
    └── vault_pass.txt
```


Troubleshooting:
If you find that after building your vms, and Ansible has deployed, provisioned without any issues, but you are not able to ping your vms via  ansible -u vagrant -i hosts all -m ping  then do check that you can ssh into them using the information from vagrant ssh-config.

Example:

ssh -i /home/klarsen/percona-pxc/.vagrant/machines/etl/virtualbox/private_key vagrant@127.0.0.1 -v -p2202

You may find that you have to delete an older entry in your vi +774 /home/klarsen/.ssh/known_hosts.  Then try it again.




License
-------

BSD

Author Information
------------------
Kurt Larsen  Las Vegas, NV
