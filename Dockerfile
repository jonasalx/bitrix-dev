FROM ubuntu:16.04
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  apache2 libapache2-mod-php7.0 php7.0-mysql php7.0-gd php7.0-mcrypt php-pear php-apcu php7.0-curl curl lynx-cur

RUN a2enmod php7.0 && a2enmod rewrite && phpenmod mcrypt

RUN \
 sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini && \
 sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini && \
 sed -i "s/display_errors = Off/display_errors = On/" /etc/php/7.0/apache2/php.ini && \
 sed -i "s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf && \
 sed -i "s/;opcache.revalidate_freq=2/opcache.revalidate_freq=0/" /etc/php/7.0/apache2/php.ini && \
 sed -i "s/;mbstring.func_overload.*$/mbstring.func_overload=2/" /etc/php/7.0/apache2/php.ini && \
 sed -i "s/;mbstring.internal_encoding.*$/mbstring.internal_encoding=UTF-8/" /etc/php/7.0/apache2/php.ini && \
 sed -i "s/;realpath_cache_size.*$/realpath_cache_size=8M/" /etc/php/7.0/apache2/php.ini && \
 sed -i "s/;mbstring.func_overload = .*/c\mbstring.func_overload = 2" /etc/php/7.0/apache2/php.ini

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

ADD http://www.1c-bitrix.ru/download/scripts/bitrixsetup.php /var/www/html/
RUN chown -R www-data:www-data /var/www/html && chown -R www-data:www-data /var/lib/php

RUN sed -i 's/;date.timezone =/date.timezone = "America\/Santiago"/g' /etc/php/7.0/apache2/php.ini

EXPOSE 80
CMD /usr/sbin/apache2ctl -D FOREGROUND
