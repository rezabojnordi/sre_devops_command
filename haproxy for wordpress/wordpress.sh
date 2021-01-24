#!/bin/bash

apt update 

apt-get --force-yes -o Dpkg::Options::="--force-confold" --force-yes -o Dpkg::Options::="--force-confdef" -fuy dist-upgrade
 
apt autoremove << EOF
y
EOF

mariadbIp="$1"
domain="$2"
echo "mariadb=$mariadbIp"
echo "domain=$domain"

apt install nginx << EOF
y
EOF

systemctl stop nginx.service
systemctl start nginx.service
systemctl enable nginx.service

apt install php-fpm php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl mariadb-client <<EOF
y
EOF

cd /tmp && wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
sudo mv wordpress /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress/
chmod -R 755 /var/www/html/wordpress/
mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

sed -i 's/database_name_here/wordpress/g' /var/www/html/wordpress/wp-config.php
sed -i 's/username_here/wordpress-user/g' /var/www/html/wordpress/wp-config.php
sed -i 's/password_here/wordpress-user@123/g' /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/$mariadbIp/g" /var/www/html/wordpress/wp-config.php

cat >> /var/www/html/wordpress/wp-config.php <<EOF
define('FORCE_SSL_ADMIN', true);
define('FORCE_SSL_LOGIN', true);
if (\$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
\$_SERVER['HTTPS']='on';
define('WP_HOME','http://$domain');
define('WP_SITEURL','http://$domain');
EOF

cat  > /etc/nginx/sites-available/wordpress << EOF
server {
    listen 80;
    listen [::]:80;
    root /var/www/html/wordpress;
    index  index.php index.html index.htm;
    server_name  $domain;

     client_max_body_size 100M;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;        
    }

    location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass             unix:/var/run/php/php7.2-fpm.sock;
    fastcgi_param   SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
EOF

rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
systemctl restart nginx

ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
systemctl restart php7.2-fpm.service


