Permissions in [[Linux]] are kind fun, here are some notes

`chown`:

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