FROM debian:jessie

MAINTAINER ATINO GmbH, info@atino.de

#install packages
RUN apt-get update && apt-get install -y \
 vim cron unzip apache2 \
 libmagickwand-dev libmagickcore-dev \
 apache2-dev build-essential libxml2-dev libssl-dev snmp libpcre3-dev libjpeg-dev libpng-dev \
 libmysqlclient-dev libgd-dev libgmp-dev libmhash-dev libmcrypt-dev libwebp-dev libc-client2007e-dev libkrb5-dev \
 libxslt-dev libsnmp-dev libzip-dev libtidy-dev libcurl4-openssl-dev libicu-dev autoconf
#############

#env vars
ENV DEBIAN_FRONTEND noninteractive

ENV PHP_VERSION "php-5.6.21"
ENV IMAGICK_VERSION "imagick-3.4.1"
ENV APACHE_LOG_DIR "/var/log/apache/"
ENV APACHE_RUN_USER "www-data"
ENV APACHE_RUN_GROUP "www-data"
#############

#compile php
COPY $PHP_VERSION.tar.gz /tmp
RUN ln -s /usr/include/ldap.h /usr/lib/x86_64-linux-gnu/ldap.h
RUN tar xf /tmp/$PHP_VERSION.tar.gz -C /tmp
RUN /tmp/$PHP_VERSION/configure --with-apxs2=/usr/bin/apxs2 --with-mysqli --with-kerberos --with-libxml-dir \
    --with-openssl --with-pcre-regex --with-zlib --enable-bcmath --enable-calendar --with-curl --enable-exif \
    --with-pcre-dir --enable-ftp --with-openssl-dir --with-gd --with-webp-dir --with-jpeg-dir --with-png-dir \
    --with-xpm-dir --with-freetype-dir --enable-gd-native-ttf --enable-gd-jis-conv --with-gettext --with-mhash \
    --with-iconv --with-imap --with-imap-ssl --enable-intl --with-icu-dir=/usr --enable-mbstring --with-mcrypt \
    --with-pdo-mysql --with-snmp --with-openssl-dir --enable-soap --enable-sockets --enable-zip --with-zlib-dir \
    --with-libzip --with-ldap=/usr/lib/x86_64-linux-gnu --with-tidy
RUN make && make install
#############

#compile imagick
COPY $IMAGICK_VERSION.tgz /tmp
RUN tar xf /tmp/$IMAGICK_VERSION.tgz -C /tmp
RUN cd /tmp/$IMAGICK_VERSION/ && phpize
RUN /tmp/$IMAGICK_VERSION/configure --with-imagick=/usr/local
RUN make && make install
#############

#configure php
RUN cp /tmp/$PHP_VERSION/php.ini-production /usr/local/lib/php.ini && ln -s /usr/local/lib/php.ini /etc
RUN echo "date.timezone = Europe/Berlin" >> /etc/php.ini
RUN echo "extension=imagick.so" >> /etc/php.ini
#############

#configure apache2
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork ssl rewrite headers

RUN echo "<FilesMatch \.php$>" >>  /etc/apache2/mods-available/php5.load && \
    echo "SetHandler application/x-httpd-php" >>  /etc/apache2/mods-available/php5.load && \
    echo "</FilesMatch>" >>  /etc/apache2/mods-available/php5.load
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN mkdir /etc/apache2/ssl
RUN a2dissite 000-default
RUN a2ensite default-ssl

RUN echo "Listen 443" /etc/apache2/ports.conf
##############
##cleanup
RUN rm -R /tmp/*
##############

EXPOSE 443

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
#ENTRYPOINT ["/entrypoint.sh"]
