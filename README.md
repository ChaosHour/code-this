dbtraining002 is the master and dbtraining003 is the slave in this Ansible Playbook.

What is needed: 
- You have both servers in your ansible hosts file.
- You have tested your connections to both servers with ansible. 
- MySQL setup and running, as this is just a reseed playbook.
- A var yml file to store your passwords. example:  mysql_repl_pass and mysql_root_pass.
- As this was not production, I have a .my.cnf file on both servers for testing.

Directory layout:
Example:

playbooks
  |
  vars
  | --> vars.yml file

run usage:

- Validate your hosts first:

ansible-playbook playbooks/db_reseed-innobackupex.yml --list-hosts

This will also let you know, if any spacing or syntax options ansible does not like.

- When comfortable with the playbook run it:

ansible-playbook playbooks/db_reseed-innobackupex.yml

I like to log into both servers to monitor the progress, as well.

- On the Master

while :; do ps -ef grep -i ansible | grep -v ansible; sleep 3; done

- On the Slave:

while :; do ls -lhrt /db/backup/* ; sleep 3; done

Just so I can see the backup is in progress of transfering.
This playbook worked, but more testing is needed.  Largest database size tested 2G; not that big. This was just a proof of concept for me.

