#!/bin/bash

function update_script()
{
    echo "updating web script..."
    wget -qO /usr/local/bin/web https://raw.githubusercontent.com/tediscript/web/master/web.sh
    chmod +x /usr/local/bin/web
    echo "web script updated!"
}

function site_create()
{
    echo "create ${1}..."
    #create folder /var/www/${1}/public/
    #create database ${1} replace . to _ for username and database
    #create site available, site enable
    echo "${1} created!"
}

function site_delete()
{
    echo "delete ${1}..."
    #delete site enable, site available
    #delete folder /var/www/${1}
    #delete database
    echo "${1} deleted!"
}

function site_enable()
{
    echo "enable ${1}..."
    #link sites-available to sites-enabled
    ln -s /etc/nginx/sites-available/${1} /etc/nginx/sites-enabled/${1}
    service nginx reload
    echo "${1} enabled!"
}

function site_disable()
{
    echo "disable ${1}..."
    #rm link in sites-enabled
    rm /etc/nginx/sites-enabled/${1}
    service nginx reload
    echo "${1} disabled!"
}

function site()
{
    #validate domain ${2}
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

if [ ${1} == "update" ]; then
    update_script
elif [ ${1} == "site" ]; then
    site ${2} ${3}
else
    echo "command not supported"
fi