Permissions in [[Linux]] are kind fun, here are some notes

`chown` and `chmod`:
```sh
chown -R floyd:Sales /SalesInfo
# change ownership to user floyd group Sales for /SalesInfo
chmod -R u=rwx,g=rx,o-rwx /SalesInfo
# change access rights for user, group, and others for folder SalesInfo
```

`chattr`:
```
+i / -i : adds an 'immutable' tag to the file
+a / -a : adds an 'append' tag to the file, which makes it un-editable
```
`lsattr` will fetch those details

Permissions numbers:
- 0 = no permissions
- 1 = Execute
- 2 = Write
- 4 = read

Groups and users:
```sh
adduser <username>
groupadd <groupname>
```