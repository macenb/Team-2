This is specifically for firewalls in [[Linux]] lol, like [[ufw]], firewalld, and iptables. Since I already have a note for ufw, this is gonna focus on the harder ones

## iptables
iptables is less forgiving than ufw. If you turn it on when the default deny is on, it will instantly cut any ssh sessions. When you restart it, any unsaved rules are gone.

Commands
```sh
# check rules
sudo iptables -L
sudo apt install iptables-persistent
sudo iptables -P INPUT DROP # drops all input incoming (default deny in)
sudo iptables -P FORWARD DROP
# allow ping
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
# allow ssh in
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# -A is in or out, -p is protocol, --dport is dest port, -j ACCEPT DROP REJECT

# save rules
iptables-save > /etc/iptables/rules.v4
```
## firewalld
Typically this is useful for machines that have zones, such as a router. For this reason, you use in in NCAE on the Router machine. Firewalld needs the permanent flag on rules you want to keep and must reload for them to take effect

Commands:
```sh
# check rules
sudo firewall-cmd --list-all-zones # without -zones is brief list
sudo firewall-cmd --list-forward-ports

# new default rule to DROP for all
sudo firewall-cmd --zone=public --set-target=DROP --permanent
# if you don't add permanent to the rule it will delete on reboot

# add ssh, it will recognize and map service to protocol
sudo firewall-cmd --zone=public --add-service=ssh --permanent

sudo firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toaddr=192.168.1.4:toport=80 --permanent

# restart firewalld
sudo firewall-cmd --reload
```

Let's go in order of the configuration we want for the router
```sh
# view all your zones
sudo firewall-cmd --list-all-zones | less # check interfaces and services in each zone
sudo firewall-cmd --list-all --zone=public # limit output to one zone

# change zones
sudo firewall-cmd --change-interface=eth1 --zone=internal --permanent
# if permanent is added, it will persist but it will not apply until restart

# port forwarding
sudo firewall-cmd --zone=external --add-forward-port=port=80:proto=tcp:toport=80:toaddr=192.168.118.2 --permanent
# forward TCP requests on port 80 to port 80 on 192.168.118.2

# remove external ssh connections to your firewall (test with your external machines)
sudo firewall-cmd --zone=external --permanent --remove-service=ssh
# add it back
sudo firewall-cmd --zone=external --permanent --add-service=ssh
# forwarding for the same service, will override potential to ssh to router
sudo firewall-cmd --zone=external --add-forward-port=port=22:proto=tcp:toport=22:toaddr=192.168.118.2 --permanent
```
Reminder, external has masquerading enabled by default and this is necessary for an external zone

Setting DNS stuff for the router is cool, too
```sh
# change the port but make sure to change the protocol, too
sudo firewall-cmd --zone=external --add-forward-port=port=53:proto=udp:toport=53:toaddr=192.168.118.2 --permanent
```