#!/bin/bash

cd /var/www/html && echo "curl $SOURCE_DOWNLOAD_LINK > download_source" >> download.sh && chmod +x download.sh && ./download.sh && rm download.sh
unzip -o -q download_source && rm download_source

chmod -R 777 /var/www/html
chmod +x $INIT_SCRIPT && ./$INIT_SCRIPT

apache2ctl -D FOREGROUND
