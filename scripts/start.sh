#!/bin/bash

# Set custom webroot
if [ ! -z "$WEBROOT" ]; then
 sed -i "s#/var/www/html\$#${WEBROOT}#g" /etc/apache2/sites-available/default.conf
 sed -i "s/\/var\/www\/html\$/${WEBROOT}/g" /etc/apache2/sites-available/default-ssl.conf
else
 webroot=/var/www/html
fi

if [ ! -z "$DOMAIN" ]; then
 sed -i "s#ServerName localhost:80#ServerName $DOMAIN:80#g" /etc/apache2/apache2.conf
 sed -i "s#ServerName localhost#ServerName $DOMAIN#g" /etc/apache2/sites-available/default.conf
 sed -i "s#ServerName localhost#ServerName $DOMAIN#g" /etc/apache2/sites-available/default-ssl.conf
fi

if [ ! -z "$PUID" ]; then
  if [ -z "$PGID" ]; then
    PGID=${PUID}
  fi
  #deluser www-data
  addgroup -g ${PGID} www-data
  adduser -D -S -h /var/cache/www-data -s /sbin/nologin -G www-data -u ${PUID} www-data
else
  if [ -z "$SKIP_CHOWN" ]; then
    chown -Rf www-data:www-data /var/www/html
  fi
fi

source /etc/apache2/envvars

rm -f /var/run/apache2/apache2.pid

exec /usr/sbin/apache2 -DFOREGROUND