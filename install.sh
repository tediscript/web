#!/bin/bash

echo "##################################"
echo "###         WebEngine          ###"
echo "##################################"

function is_valid_email() {
      regex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
      [[ "${1}" =~ $regex ]]
}

function setup_config()
{
    mkdir -p /etc/web

    mysql_config=/etc/web/mysql.conf
    password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "user=root" > ${mysql_config}
    echo "password=${password}" >> ${mysql_config}
}

function install_script()
{
    wget -qO /usr/local/bin/web https://raw.githubusercontent.com/tediscript/web/master/web.sh
    chmod +x /usr/local/bin/web
}

function install_stack()
{
    sudo apt update -y
    sudo apt upgrade -y

    #nginx
    sudo apt install nginx -y
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.save
    wget -qO /etc/nginx/nginx.conf https://raw.githubusercontent.com/tediscript/web/master/nginx.conf
    systemctl start nginx
    systemctl enable nginx

    #php
    sudo apt install php7.4 php7.4-cli php7.4-common php7.4-curl php7.4-dev php7.4-fpm php7.4-gd php7.4-imagick php7.4-imap php7.4-intl php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-soap php7.4-sqlite3 php7.4-xml php7.4-xmlrpc php7.4-zip -y
    sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.4/fpm/php.ini
    systemctl start php7.4-fpm
    systemctl enable php7.4-fpm
    apt install composer -y

    #mysql
    sudo apt install mariadb-server mariadb-client -y
    systemctl start mysql
    systemctl enable mysql
    mysql --user=root <<_EOF_
      UPDATE mysql.user SET Password=PASSWORD('${password}') WHERE User='root';
      DELETE FROM mysql.user WHERE User='';
      DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
      DROP DATABASE IF EXISTS test;
      DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
      FLUSH PRIVILEGES;
_EOF_

    #certbot
    sudo apt-get update
    sudo apt-get install software-properties-common -y
    sudo add-apt-repository universe -y
    sudo apt-get update
    apt install python3-certbot-nginx -y
    
    #utilities
    apt install zip unzip -y

    apt autoremove -y
}

##============##MAIN##============##

setup_config
install_script
install_stack

echo "Stack installation done!"
