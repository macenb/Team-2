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
The exclude statement might be in any of the following locations:
- `/etc/yum/yum.conf` or `/etc/yum.conf`
- `/etc/yum.repos.d/*`
- `/etc/yum/protected.d/*`
- `/etc/yum/yum.conf.d/*`
You may need to `yum update` to get it working from there
If you're working with DNF, try checking here:
- `/etc/dnf/protected.d/*`
- `/etc/dnf/dnf.conf.d/*`
These files will have a line that looks like `excludepkgs=*`
You can also use versionlock by running something like:
```sh
sudo dnf install dnf-plugins-core
sudo dnf versionlock list
sudo dnf versionlock delete <package-name>
```

Services:
You can find daemon files in `/lib/systemd/system`

Keyloggers:
Typically password loggers will be a line in the `/etc/pam.d/` folder and often in the `common-auth` file specifically
Or in Rocky or CentOS it'll be in `password-auth`

You can manually exit a specific aspect of a function by opening `gdb -p $(pid)` and running `call close($(file descriptor)` and then `exit`. You can also probably pull `gdb` without `apt` or `yum` by just `curl`ing it

Is psid 1 actually `init`? Is `init` actually pointing to `/lib/systemd/systemd`? Fun questions to ask