# WebEngine
Command-line control panel for Ubuntu 18.04 to manage web sites running on Nginx, PHP, MySQL, and Let's Encrypt. Inspired by EasyEngine.

## Installation

We have created an installer script which will install all the dependencies for you. We have tested this on Ubuntu 18.04.

```bash
wget -qO web bit.ly/web-script && sudo bash web
```

Even if the script doesn't work for your distribution, you can manually install the dependencies and then run the following commands to install WebEngine

```bash
wget -O /usr/local/bin/web https://raw.githubusercontent.com/tediscript/web/master/install.sh
chmod +x /usr/local/bin/web
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

Command to update WebEngine with latest version

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

## License
[MIT License](http://opensource.org/licenses/MIT)