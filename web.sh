#!/bin/bash

function version()
{
    echo "WebEngine v0.6.0-dev"
}

function update_script()
{
    if [ $# -eq 0 ]; then
        echo "updating from master..."
        wget -qO /usr/local/bin/web https://raw.githubusercontent.com/tediscript/web/master/web.sh
    elif [ ${1} == "--dev" ]; then
        echo "updating from dev..."
        wget -qO /usr/local/bin/web https://raw.githubusercontent.com/tediscript/web/dev/web.sh
    else
        version
    fi
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

function site_create_database()
{
    local name=${1//[^a-z0-9]/_}
    local pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    
    #create mysql user and database
    mkdir -p /var/www/${1}/conf
    echo "### MySQL Config ###
database=${name}
username=${name}
password=${pass}" > /var/www/${1}/conf/mysql.conf

    #create database
    . /etc/web/mysql.conf
    mysql --user=root --password=${password} -e "CREATE DATABASE IF NOT EXISTS ${name};
    CREATE USER '${name}'@'localhost' IDENTIFIED BY '${pass}';
    GRANT ALL PRIVILEGES ON ${name}.* TO '${name}'@'localhost';
    FLUSH PRIVILEGES;"
}

function site_create_web_directory()
{
    echo "create web directory for ${1}..."
    mkdir -p /var/www/${1}/src/public
    echo "<h1>It works!</h1>" > /var/www/${1}/src/public/index.php
    chown -Rf www-data:www-data /var/www/${1}/src
    echo "directory created!"
}

function site_create_nginx_conf()
{
    echo "create nginx config for ${1}..."
    echo "### ${1} ###
server {
    listen 80;

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

    #create web root and default index.php file
    site_create_web_directory ${1}

    #create database
    site_create_database ${1}

    #create nginx configuration
    site_create_nginx_conf ${1}

    #enable site
    site_enable ${1}
    echo "${1} created!"
}

function site_delete()
{
    echo "delete ${1}..."
    
    #delete site enable
    site_disable ${1}
    
    #site available
    echo "delete nginx conf..."
    rm /etc/nginx/sites-available/${1}
    echo "nginx conf deleted!"

    #delete folder /var/www/${1}
    echo "delete web root directory..."
    rm -Rf /var/www/${1}
    echo "web root directory deleted!"

    #delete database
    echo "delete database..."
    local name=${1//[^a-z0-9]/_}
    . /etc/web/mysql.conf
    mysql -u root -p${password} -e "DROP DATABASE IF EXISTS ${name}; 
    DROP USER '${name}'@'localhost';"
    echo "database deleted!"

    echo "${1} deleted!"
}

function site_list()
{
    echo "all sites:"
    ls /etc/nginx/sites-available | egrep -v '*\.save'
    echo "active sites:"
    ls /etc/nginx/sites-enabled | cat
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
    elif [ ${1} == "list" ]; then
        site_list
    else
        echo "command not supported"
    fi
}

###========###MAIN###========###

if [ ${1} == "-v" ]; then
    version
elif [ ${1} == "update" ]; then
    update_script ${2}
elif [ ${1} == "site" ]; then
    site ${2} ${3}
else
    echo "command not supported"
fi
