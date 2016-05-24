#!/bin/bash

apt-get update -y
apt-get install -y unzip apache2 php5 php5-mysql
/usr/sbin/a2enmod rewrite expires headers

tar xvfz "$1" --directory /

/usr/sbin/useradd 24h
chown -R 24h:www-data /var/www
chmod -R 775          /var/www

/usr/sbin/a2ensite 010-24h
/usr/sbin/a2dissite 000-default
/usr/sbin/service apache2 reload
/etc/init.d/apache2 restart

echo "$2" > host.txt
