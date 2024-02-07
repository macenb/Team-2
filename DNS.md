DNS config for [[Linux]] machines, specifically for NCAE Cybergames

Likely this is going to be in a config file in `/etc/bind/`, which hosts the config files for `bind` aka `named`
Check status by running `systemctl status named` (BIND DNS)
If you check your `named.conf`, it'll likely just link to other conf files, so check around to configure that service into those ones

So you will need to add zones, here is the format for this (potentially to `named.conf.default-zones`):
```sh
# forward lookup
zone "ncaecybergames.org" IN { # you can find record in files...
	type master; # master record
	file "/etc/bind/zones/forward.ncaecybergames"; # file with associated record
	allow-update { none; }; # don't allow updates to the record
};

# reverse lookup
# bind will reverse the address (reverse arpa notation)
# you only need the NETWORK information, so for 192.168.8.2/24, this is just 192.168.8
zone "8.168.192.in-addr.arpa" IN {
	type master;
	file "/etc/bind/zones/reverse.ncaecybergames";
	allow-update { none; };
};

zone "20.172.in-addr.arpa" IN {
	type master;
	file "etc/bind/zones/reverse.ncaecybergames";
	allow-update { none; };
};
```

In your actual file that your zone points to, it will look like this for forward addresses:
```sh
# make a copy of db.empty to make a new file formatted like this
# ownership and group and permissions will all transfer that way. root-bind-644
# there will be stuff above here, specifically localhost stuff
$TTL   86400
@      IN      SOA     ncaecybergames.org root ( # overarching record
                        2       ; Serial # must be incrimented with each file change
                   604800       ; Refresh
                    86400       ; Retry
                  2419200       ; Expire
                    86400 )     ; Negative Cache TTL
@      IN      NS       hostname
subdomain   IN A   192.168.8.2 # this is an A record, so it's marked with 'A'
www         IN A   192.168.8.2 # just make the ip point to the right place
```
Look at the existing files (like `db.local`) for more guidance. Note the serial incrementation allows the file to recognize changes, and the subdomains all sit below the main record

For reverse lookup files:
```sh
# make a copy of db.empty to make a new file formatted like this
# ownership and group and permissions will all transfer that way. root-bind-644
# there will be stuff above here, specifically localhost stuff
$TTL   86400
@      IN      SOA     ncaecybergames.org. root.ncaecybergames.org. (
                        2       ; Serial # must be incrimented with each file change
                   604800       ; Refresh
                    86400       ; Retry
                  2419200       ; Expire
                    86400 )     ; Negative Cache TTL
@      IN      NS       hostname.
2      IN PTR  www.ncaecybergames.org. # this is a PTR record, so 'PTR'
2      IN PTR  hostname.ncaecybergames.org.
1.0    IN PTR  score.ncaecybergames.org.
```
Note the periods after the domain names this time around, that's notable for the reverse lookups only. Instead of subdomains, we write any localhost information (network information was in the conf file) in reverse order (arpa). In the example, it is looking for `.2` as the last octet of our `192.168.8` network. You can see how those two files are referencing each other in terms of ip v DNS names
You can actually throw multiple ip addresses into the same domain by making two different indexes in `named.conf.default-zones`, but by pointing to the same file, where you have different resolutions in the subdomain section. For example, the last line in the reverse file is pointed to not by our 8.168.192 entry, but by the 20.172 entry.

BIND conf stuff
```sh
systemctl status named
sudo systemctl start named
sudo systemctl restart named
```

This will set up your 'Name Server', which you then need to point to in network configurations of other machines.

### DNS Troubleshooting
`nslookup www.websitename.org`
`nslookup 192.168.8.2`
