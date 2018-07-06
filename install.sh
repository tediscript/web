#!/bin/bash

function is_valid_email() {
      regex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
      [[ "${1}" =~ $regex ]]
}

function save_config()
{
    mkdir -p /etc/web

    echo "Admin user:"
    read user

    echo "Admin email:"
    read email
    while !(is_valid_email ${email}) ; do
        echo "Invalid email. Pleas try again"
        echo "Admin email:"
        read email
    done

    app_config=/etc/web/app.conf
    echo "user=${user}" > ${app_config}
    echo "email=${email}" >> ${app_config}

    mysql_config=/etc/web/mysql.conf
    password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "user=root" > ${mysql_config}
    echo "password=${password}" >> ${mysql_config}
}

function install_script()
{
    echo 'download script...'
}

function install_stack()
{
    sudo apt update -y
    sudo apt upgrade -y

    sudo apt install nginx -y
    systemctl start nginx
    systemctl enable nginx

    sudo apt install php7.2 php7.2-curl php7.2-common php7.2-cli php7.2-mysql php7.2-mbstring php7.2-fpm php7.2-xml php7.2-zip -y
    sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/fpm/php.ini
    systemctl start php7.2-fpm
    systemctl enable php7.2-fpm

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

    apt install composer -y
    
    apt autoremove -y
}

##============##MAIN##============##
echo "###################################"
echo "### LEMP Stack for Ubuntu 18.04 ###"
echo "###################################"
save_config
install_script
install_stack

echo "Done!"
