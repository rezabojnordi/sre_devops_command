#!/usr/bin/env bash

echo "install apache and settingh apache up ...... please wait"
apt update  >/dev/null 2>&1

apt install -y apache2 >/dev/null 2>&1
rm -rf  /var/www

ln -fs /vagrant /var/www 

