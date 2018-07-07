#!/bin/bash

function version()
{
    echo "Web v0.2.0"
}

function update_script()
{
    echo "updating web script..."
    wget -qO /usr/local/bin/web https://raw.githubusercontent.com/tediscript/web/master/web.sh
    chmod +x /usr/local/bin/web
    echo "web script updated!"
    web -v
}

function site_enable()
{
    echo "enable ${1}..."
    ln -s /etc/nginx/sites-available/${1} /etc/nginx/sites-enabled/${1}
    service nginx reload
    echo "${1} enabled!"
}

function site_disable()
{
    echo "disable ${1}..."
    rm /etc/nginx/sites-enabled/${1}
    service nginx reload
    echo "${1} disabled!"
}

function site_create_mysql_conf()
{
    mkdir -p /var/www/${1}/conf
    echo "### MySQL Config ###
database=${name}
username=${name}
password=${password}" > /var/www/${1}/conf/mysql.conf
}

function site_create_root_directory()
{
    echo "create root directory for ${1}..."
    mkdir -p /var/www/${1}/src/public
    echo "<h1>It works!</h1>" > /var/www/${1}/src/public/index.php
    echo "directory created!"
}

function site_create_sites_available()
{
    echo "create nginx config for ${1}..."
    echo "### ${1} ###
server {
    listen 80;
    listen [::]:80 ipv6only=on;

    if (\$host = www.${1}) {
        return 301 \$scheme://${1}\$request_uri;
    }

    # Webroot Directory
    root /var/www/${1}/src/public;
    index index.php index.html index.htm;

    # Your Domain Name
    server_name www.${1} ${1};

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    # PHP-FPM Configuration Nginx
    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    # Log files for Debugging
    access_log /var/log/nginx/${1}-access.log;
    error_log /var/log/nginx/${1}-error.log;
}
" > /etc/nginx/sites-available/${1}
    echo "nginx config created!"
}

function site_create()
{
    #check is domain exist (and sites-available)
    echo "create ${1}..."
    #create username and database: ${1} replace . to _
    local name=${1//\./_}
    #cerate password
    local password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    #save username, password to config file
    site_create_mysql_conf ${1}
    #create mysql user and database

    #create default index.php file
    site_create_root_directory ${1}
    #create site available
    site_create_sites_available ${1}
    #site enable
    site_enable ${1}
    echo "${1} created!"
}

function site_delete()
{
    echo "delete ${1}..."
    #delete site enable
    site_disable ${1}
    #site available
    rm /etc/nginx/sites-available/${1}
    #delete folder /var/www/${1}
    rm -Rf /var/www/${1}
    #delete database
    echo "${1} deleted!"
}

function site()
{
    #TODO: validate domain ${2}
    if [ ${1} == "create" ]; then
        site_create ${2}
    elif [ ${1} == "delete" ]; then
        site_delete ${2}
    elif [ ${1} == "enable" ]; then
        site_enable ${2}
    elif [ ${1} == "disable" ]; then
        site_disable ${2}
    else
        echo "command not supported"
    fi
}

###========###MAIN###========###

if [ ${1} == "-v" ]; then
    version
elif [ ${1} == "update" ]; then
    update_script
elif [ ${1} == "site" ]; then
    site ${2} ${3}
else
    echo "command not supported"
fi