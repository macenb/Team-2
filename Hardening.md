Change default passwords
Remove bad users
Remove bad SSH keys
Give only certain users SSH access
Go through the conf files
Back up everything you can

`/etc/passwd`: Check if a user has `nologin` or `/bin/bash`
`/etc/shadow`: Check if a user has a hash
	If a user has `username:*:...`, they have no login
	If a user has `username::...`, they have no password
If you see a malicious user 