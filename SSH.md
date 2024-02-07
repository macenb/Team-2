Config files:
- `/etc/ssh/sshd_config`
	- Port 22
	- PermitRootLogin : allows people to login as the root user over ssh, usually disable
	- Max Sessions : set a max number of users, limit it to you and scoring
	- AuthorizedKeysFile : lets you select a location to add key pairs (two by default, lock it down). Red team likes to either add more to the one line or add a second line with their custom
	- Permit Empty Passwords: 
	- PasswordAuthentication : once you have keys enabled, just turn off password authentication, check ownership and permissions, too
	- *** `UsePAM yes` *** : this lets you authenticate
```sh
LoginGraceTime 2m
PermitRootLogin no
MaxAuthTries 6
MaxSessions 5

PubkeyAuthentication yes

AuthorizedKeysFile ...

PasswordAuthentication no # this also stops key copy
PermitEmptyPasswords no
```
- `/etc/ssh/sshd_config.d/05-cloud-init.conf`
	- PasswordAuthentication : you need this off here and in `sshd_config` to turn off password authentication
For a user, `~/.ssh/authorized_keys`:
- Public keys go here
- Check all authorized users for correct keys
- Back up good keys in a safe location
- Probably back up `/etc/shadow`, too for passwords

You can generate ssh keys using the `ssh-keygen` command:
	You'll need to specify a keyfile
	-t : type of key, ex rsa or ecdsa
	-f : file location, you can overwrite the existing keys and probably should if your computer is a clone
Copy the public key to the remote host:
`ssh-copy-ip -i <key.pub> user@ip.ad.dr.ess`
To connect: 
`ssh -i <key> user@ip.ad.dr.ess` 

`sudo apt install openssh-server`
`systemctl status ssh` or `systemctl status sshd`

Permissions for config files:
```
-rw-r--r-- root root ssh_config
-rw-r--r-- root root sshd_config
-rw------- root root ssh_key
-rw-r--r-- root root ssh_key.pub
```