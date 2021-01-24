#!/bin/bash

apt update 

apt-get --force-yes -o Dpkg::Options::="--force-confold" --force-yes -o Dpkg::Options::="--force-confdef" -fuy dist-upgrade
 
apt autoremove << EOF
y
EOF


server1="$1"
server2="$2"


apt install  mariadb-server mariadb-client << EOF
y
EOF

systemctl stop mariadb.service
systemctl start mariadb.service
systemctl enable mariadb.service
mysql_secure_installation << EOF
\n
Y
wordpress-user@123
wordpress-user@123
Y
N
Y
Y
EOF

mysql -u root -e "CREATE DATABASE wordpress;" -e "CREATE USER 'wordpress-user'@'localhost' IDENTIFIED BY 'wordpress-user@123';" -e "GRANT ALL ON wordpress.* TO 'wordpress-user'@'localhost' IDENTIFIED BY 'wordpress-user@123' WITH GRANT OPTION;" -e "CREATE USER 'wordpress-user'@'$server1' IDENTIFIED BY 'wordpress-user@123';" -e "GRANT ALL ON wordpress.* TO 'wordpress-user'@'$server1' IDENTIFIED BY 'wordpress-user@123' WITH GRANT OPTION;" -e "CREATE USER 'wordpress-user'@'$server2' IDENTIFIED BY 'wordpress-user@123';" -e "GRANT ALL ON wordpress.* TO 'wordpress-user'@'$server2' IDENTIFIED BY 'wordpress-user@123' WITH GRANT OPTION;" -e "FLUSH PRIVILEGES;"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

systemctl restart mysql