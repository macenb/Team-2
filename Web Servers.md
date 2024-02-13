### Apache2
```sh
systemctl status apache2 # or httpd or nginx, find out what's there
systemctl start apache2 # this will start it running
systemctl enable apache2 # this makes it so the system is started on system start
```

Config files:
`/etc/apache2`
First of all, `envvars` is an awfully handy file to start with since it shows you where logging happens and a couple other things
Then look at `apache2.conf` to see how those are used in the actual path. Check include statements here, then you'll need to edit some of the configured directories. Specifically, make sure `<Directory /var/www/>` (which should be the directory for Apache2 configured) doesn't include `Indexes` in its `Options`, since that is directory traversal

Some of your config files, such as files in `sites-available/`, are there to tell your apache2 service what to do. Here's how they will look:
```sh
<VirtualHost *:80>
	DocumentRoot /var/www/html # this is where your website exists
</VirtualHost>
```
This file also contains the error log locations for the website in question.
In each of the `-available` folders, it contains a set of config files that the `-enabled` folder contains symbolic links to. Permissions for everything should be `644`

Permissions:
File permissions should be `644` at least, so the website can read them

# NGINX
Config files in `/etc/nginx`
nginx runs really similar to Apache2, but with a couple differences. The structure is the same as in Apache2, there are `sites-available` and `sites-enabled` sections that have config for the individual sites. 
```sh
server {
       listen 80;
#       listen 443 ssl;
       listen [::]:80;

       server_name example.com;

       root /var/www/example.com;
       index index.html;

       location / {
               try_files $uri $uri/ =404;
       }
}
```
First line is ipv4, adding `default_server` will set it as a default. Commented is for ssl config
Second line is ipv6, adding `default_server`
Root folder, then index files, in order left to right for what it looks for.
Location will, as you add files to the url, try_files first by filename, then by folder name, then throw error 404

Um `fastcgi.conf` probably contains like variables and the like for dynamically generated website content like Python or PHP
`koi-` is charsets. You should have `win` and `utf` by default
`mime.types` contains a content-type reference for nginx

### PHP
I'm not sure, but I'm almost positive that the website uses PHP, which means you should probably harden up the PHP code and config files. Here's some more information.
All of this info minus my witty banter can be found at the [OWASP Site](https://cheatsheetseries.owasp.org/cheatsheets/PHP_Configuration_Cheat_Sheet.html)

Config files:
`/etc/php/<version>/apache2/`, specifically `php.ini`
Ideal settings:
```sh
expose_php = Off # doesn't expose the fact that php is being used to the user
error_reporting = E_ALL # internal error reporting
display_errors = Off # this makes it so your site won't show php errors to the user
display_startup_errors  = Off
log_errors = On # this is important, it'll help you figure out what's broken =
error_log = /valid_path/PHP-logs/php_error.log # LOG LOCATION
```
This deserves a pause. PHP will log errors to stderr by default, so it may be useful to choose where they get logged to. The default log is commented out in the `php.ini` file underneath `report_memleaks`
```sh
ignore_repeated_errors = Off
```
Starting with `doc_path` there are a bunch of path components that I think you can just leave blank if you're running the server with Apache2? If it's not working, maybe try filling those bad boys in.
```sh
file_uploads = Off # if you need to upload files then turn it on ig
upload_tmp_dir = # set this if you want to have some visibility, it controls where files go. System default is used if not set and is /tmp
upload_max_filesize = 2M
max_file_uploads = 2 # lol this is per request, just lock it down
```
Now you want to make sure that PHP can't execute system commands cuz that's bad:
```sh
enable_dl = Off # this should be above file uploads settings
### IMPORTANT : these functions allow RCE, big bad stuff right here
disable_functions = system, exec, shell_exec, passthry, phpinfo, show_source, highlight_file, popen, proc_open, fopen_with_path, dbmopen, dbase_open, putenv, move_uploaded_file, chdir, mkdir, rmdir, chmod, rename, filepro, filepro_rowcount, filepro_retrieve, posix_mkfifo
# you can find these two lines around line 323, above expose_php and those first config settings
disable_classes = 
```
NOW some last but definitely not least type stuff if you're still reading this. Behold, session handling:
```sh
session.save_path = <path> # good to know, and you can change it.
session.name = myPHPSESSID # change this to something new. Makes you harder to mess with
session.auto_start = Off
session.use_trans_sid = 0
session.cookie_domain = full.qualified.domain.name
#session.cookie_path = /application/path/
session.use_strict_mode = 1
session.use_cookies = 1
session.use_only_cookies = 1
session.cookie_lifetime = 14400 # 4 hours
session.cookie_secure = 1
session.cookie_httponly = 1
session.cookie_samesite = Strict
session.cache_expire = 30
session.sid_length = 256
session.sid_bits_per_character = 6
```

### SSL Certificates
Certs can be done with openssl. but huge disclaimer, I've done a little bit of this in practice and I have no idea how it would look in a competition setting...
```sh
### Generate a private RSA key, length is last param, uses current directory
openssl genpkey -algorithm RSA -out website.com.key -pkeyopt rsa_keygen_bits:2048

### Generate an associated RSA public key
openssl pkey -in website.com.key -pubout -out website.com_public.key

### Request a cert for your website (Certificate Signing Request)
openssl req -new -key website.com.key -out website.com.csr
### This certificate can be sent to validate the key

### From what I found, it looks like you need to send a certificate via curl to a website?? Here's what that command might look like, but I might be super wrong
curl -X POST -H "Content-Type: application/pkcs10" --data-binary @website.com.csr https://example.com/ca/endpoint
```

### Hardening PHP
So there is sooo much that will go into this, but needless to say web will be pretty busy. Here are some basic ideas for starting point based on the vulnerable website Sebastian gave us:
- make sure the config file with passwords is not just a json file in the directory. It should be a .env file so it's properly hidden.
- Check database queries to make sure they're using prepared statements
- Check user input to make sure it's being sanitized

### Writing PHP:
env files can be used using the `getenv("VARIABLE_NAME")` function. Make the env file and then run this bash script:
```
#!/usr/bin/env bash

echo "set -o allexport
. `pwd`/.env
set +o allexport" >> /etc/apache2/envvars
```
It essentially just `echo`s all the variables into the `envvars` file from earlier.
#### I was gonna write more but then I got lazy... if you need reference code just ask me it's on my personal GitHub

### Troubleshooting
You're going to want to get good at some basic troubleshooting commands and locations. When your service goes down or is down, you will likely need to check logs to see what red team did, especially if you already checked your config files. If file permissions change or there is a typo in a config file, it will break your whole service.
Here are some useful commands and locations:
- `systemctl` : this will output minimal bug details and the fact that your service is down. Especially pay attention to the output of `systemctl status`, since that will have details on settings associated with the service such as `enable`/`disable` and `active`/`inactive`
- `journalctl` : this will output information from your `systemd-journal`, which contains detailed information about running processes, especially bugs and other things. This is useful when paired with the `tail` command to see the most recent alerts and logs