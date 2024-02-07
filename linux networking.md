Configuring network services in [[Linux]]

You can see network details by running `ip a`

## interfaces (Kali)
In the file `/etc/network/interfaces` you can set up your machine's network interfaces manually to have an ip address.
Format for an interface (check the actual interface on your computer first):
```sh
auto eth0
iface eth0 inet static # static for setting it manually. Can be dhcp as well
	address 172.20.118.100
	netmask 255.255.0.0
	gateway 192.168.118.1 # if needed
```
You can apply these changes by running `sudo systemctl restart networking` (make sure the service name is right tho)
You can add nameserver information in `/etc/resolv.conf` by adding the line:
`nameserver 192.168.8.2` where the ip address is either the DNS server or the local router that knows how to get there

## ifcfg (CentOS)
In CentOS and other distros, that file doesn't exist. In this case, you'll have to go configure the files in `/etc/sysconfig/network-scripts/`. They will be named after your network interfaces, for example: `ifcfg-eth0`
Here are the changes you might need to make:
```sh
BOOTPROTO=static #instead of dhcp
ONBOOT=yes #instead of no
IPADDR=172.20.118.100
NETMASK=255.255.0.0
ZONE=external # this is one way to apply firewalld zones to an interface
```
You can apply these changes by running `sudo systemctl restart network`

## netplan (Ubuntu)
In `/etc/netplan/`, you can usually find a `.yaml` file, which you will edit to configure the address
```sh
# make sure your tabbing is consistent
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ens18:
      addresses:
        - 192.168.118.2/24
      gateway4: 192.168.118.1
```
You can apply these changes by running `sudo netplan apply`
For an ubuntu web server, it will need a default gateway, which will be the address of your router. Add under ens18 as another entry, as shown.

You can add nameserver information in `/etc/resolv.conf` by adding the line:
`nameserver 192.168.8.2`
