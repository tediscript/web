# WebEngine
Command-line control panel for Ubuntu 18.04 to manage web sites running on Nginx, PHP, MySQL, and Let's Encrypt. Inspired by EasyEngine.


## Version

WebEngine v0.5.2


## Installation

We have created an installer script which will install all the dependencies for you. We have tested this on Ubuntu 18.04. Only support for fresh installed Ubuntu.

```bash
wget -qO web bit.ly/web-script && sudo bash web
```


## Usage

To get started with WebEngine and create a PHP site, run

```
web site create example.com
```

Delete sites webroot and database

```
web site delete example.com
```

Disable web

```
web site disable example.com
```

Enable web

```
web site enable example.com
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
    app.conf
/var/www/domain.com/
    conf/
        mysql.conf
    src/
    public/
        index.php
```

- MySQL root password stored in `/etc/web/mysql.conf`
- Default app username and email stored in `/etc/web/app.conf`
- MySQL user password for each domain stored in `/var/www/example.com/conf/mysql.conf`
- App folder is `/var/www/example.com/src/`
- Web root or public folder is `/var/www/example.com/src/public/`


## App Installed

- nginx
- php7.2 
- php7.2-curl 
- php7.2-common 
- php7.2-cli 
- php7.2-mysql 
- php7.2-mbstring 
- php7.2-fpm 
- php7.2-xml 
- php7.2-zip
- composer
- mariadb-server 
- mariadb-client
- software-properties-common
- python-certbot-nginx
- zip
- unzip


## Roadmap
- `web site info example.com` command for web information
- Install in existing server (installed MySQL, nginx and PHP)

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


