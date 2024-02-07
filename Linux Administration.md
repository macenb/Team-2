In [[Linux]], here are some important files
```sh
/etc/ssh
/etc/shadow
/etc/passwd
/etc/netplan (ubuntu)
/etc/groups
/etc/sudoers
/etc/systemd/
/home
/etc/crontab
/etc/cron.*
/var/spool/cron/crontabs
/etc/hosts
~/.bashrc
/etc/rsyslog.conf
/etc/rsyslog.d
/var/log/
```

Things to watch out for while hardening:
- `etc/hosts` is important because if your hostname is wrong it'll break a bunch of stuff
- check cron jobs for malicious stuff, but don't delete unless you double check
- Make sure your stuff is logging properly and only logging what it should log (passwords)