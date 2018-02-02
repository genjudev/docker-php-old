#!/bin/bash

##build certs
[ -f /etc/apache2/ssl/server.key ] || openssl genrsa -out /etc/apache2/ssl/server.key 2048
[ -f /etc/apache2/ssl/server.csr ] || openssl req -new -key /etc/apache2/ssl/server.key -out /etc/apache2/ssl/server.csr -subj '/CN=/C=DE'
[ -f /etc/apache2/ssl/server.crt ] || openssl x509 -req -days 3650 -in /etc/apache2/ssl/server.csr -signkey /etc/apache2/ssl/server.key -out /etc/apache2/ssl/server.crt
##############

cd /var/www/html && echo "curl $SOURCE_DOWNLOAD_LINK > download_source" >> download.sh && chmod +x download.sh && ./download.sh && rm download.sh
unzip -o -q download_source && rm download_source

chmod -R 777 /var/www/html
chmod +x $INIT_SCRIPT && ./$INIT_SCRIPT

apache2ctl -D FOREGROUND