# WebEngine
Command-line control panel for Ubuntu 20.04 to manage web sites running on Nginx, PHP, MySQL, and Let's Encrypt. Inspired by EasyEngine.


## Version

WebEngine v1.0.0


## Installation

We have created an installer script which will install all the dependencies for you. We have tested this on Ubuntu 20.04. Only support for fresh installed Ubuntu.

```bash
wget -qO web bit.ly/web-script && sudo bash web
```


## Usage

To get started with WebEngine and create a PHP site, run

```
web site create domain.com
```

Delete sites webroot and database

```
web site delete domain.com
```

Disable web

```
web site disable domain.com
```

Enable web

```
web site enable domain.com
```

List all web

```
web site list
```

Command to update WebEngine to latest version

```
web update
```

Enable HTTPS using Let's Encrypt certificate

```
certbot --nginx
```

Automating Let's Encrypt certificate renewal

```
certbot renew --dry-run
```


## Folder Structure And Configuration

```
/etc/web/
    mysql.conf
/var/www/domain.com/
    conf/
        mysql.conf
    log/
    	access.log
    	error.log
    src/
    	public/
        	index.php
```

- MySQL root password stored in `/etc/web/mysql.conf`
- Default app username and email stored in `/etc/web/app.conf`
- MySQL user password for each domain stored in `/var/www/domain.com/conf/mysql.conf`
- App folder is `/var/www/domain.com/src/`
- Web root or public folder is `/var/www/domain.com/src/public/`


## App Installed

- composer
- mariadb-server 
- mariadb-client
- nginx
- php7.4 
- php7.4-cli
- php7.4-common 
- php7.4-curl
- php7.4-fpm
- php7.4-mbstring
- php7.4-mysql
- php7.4-sqlite3
- php7.4-xml
- php7.4-zip
- python-certbot-nginx
- software-properties-common
- unzip
- zip


## Roadmap
- `web site info domain.com` command for web information
- `web site create domain.com laravel` command to create Laravel site
- `web site create domain.com wordpress` command to create WordPress site
- `web site create domain.com phpmyadmin` command to create phpMyAdmin site

## Reference

- [EasyEngine - WordPress On Nginx Made Easy!](https://easyengine.io/)
- [How to Install Laravel 5.6 PHP Framework with Nginx on Ubuntu 18.04](https://www.howtoforge.com/tutorial/ubuntu-laravel-php-nginx/)


## License
[MIT License](http://opensource.org/licenses/MIT)

### Quick Summary by [tl;drLegal](https://tldrlegal.com/license/mit-license)
A short, permissive software license. Basically, you can do whatever you want as long as you include the original copyright and license notice in any copy of the software/source.  There are many variations of this license in use.

| Can | Cannot | Must |
| --- | ------ | ---- |
| Commercial Use | Hold Liable | Include Copyright |
| Modify |  | Include License |
| Distribute |  |
| Sublicense |  |
| Private Use |  |


