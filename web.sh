#!/bin/bash

function update_script()
{
    echo "update script..."
    # download to /usr/local/bin/web, chmod +x
}

function site_create()
{
    echo "site create ${1}"
    #create folder /var/www/${1}/public/
    #create database ${1} replace . to _ for username and database
    #create site available, site enable
}

function site_delete()
{
    echo "site delete ${1}"
    #delete site enable, site available
    #delete folder /var/www/${1}
    #delete database
}

function site_enable()
{
    echo "site enable ${1}"
    #link sites-available to sites-enabled
    ln -s /etc/nginx/sites-available/${1} /etc/nginx/sites-enabled/${1}
    service nginx reload
}

function site_disable()
{
    echo "site disable ${1}"
    #rm link in sites-enabled
    rm /etc/nginx/sites-enabled/${1}
    service nginx reload
}

function site()
{
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