startufw is a [[Linux]] firewall that is really nice because it's really easily configurable

Command examples
```
sudo ufw status verbose
sudo ufw reset
sudo ufw enable
sudo ufw reload
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow 22/tcp
sudo ufw deny from 192.168.100.25
sudo ufw deny in on eth0 from 192.168.100.26cd
```

ufw has a default deny rule, so don't enable it just because, make sure it's configured right

/etc/apt/preferences.d
Check pins for ufw to let it actually install

Good rules:
```sh
sudo ufw allow OpenSSH
sudo ufw allow 22/tcp
```