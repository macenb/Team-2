2 ports: 20 is data port, 21 is command port
Competition machines use VSFTPD
Conf: `/etc/vsftpd.conf`
You will be scored on read and write:
- Write works by default
- To get read to work:
	- Mount drive (in `/mnt`)
	- Enable read in conf
	- Back up the files!
`/etc/vsftpd.conf`:
```
connect_from_port_20=YES
anon_mkdir_write_enable=NO
anon_mkdir_read_enable=NO
write_enable=YES
anonymous_enable=NO
```
Make sure you check this stuff often so you keep them out. Back it up, too. Before you modify it and then after you get it working.