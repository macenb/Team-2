`ps aux`
`lsof -i`
`who`
`netstat -tulna`

`loginctl`
`loginctl terminate-session <sid>`

Firewall pins
`/etc/yum/yum.conf` or `/etc/yum.conf` will have a line that is formatted like the following with all package pins:
`exclude=apache2 firewalld iptables ufw`
When you remove a pin, you have to usually run `yum update` to have that take effect

Services:
You can find daemon files in `/lib/systemd/system`

Keyloggers:
Typically password loggers will be a line in the `/etc/pam.d/` folder and often in the `common-auth` file specifically
Or in Rocky or CentOS it'll be in `password-auth`