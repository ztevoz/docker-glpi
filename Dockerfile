FROM debian:10.4

ENV DEBIAN_FRONTEND noninteractive

ARG GLPI_VERSION=9.5.1
ARG FUSION_INVENTORY_PATH="https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi9.5.0%2B1.0/fusioninventory-9.5.0+1.0.tar.bz2"
ARG FUSION_INVENTORY_TGZ=fusioninventory-9.5.0+1.0.tar.bz2

RUN apt update \
&& apt install --yes --no-install-recommends \
apache2 \
bzip2 \
php7.3 \
php7.3-mysql \
php7.3-ldap \
php7.3-xmlrpc \
php7.3-imap \
curl \
php7.3-curl \
php7.3-gd \
php7.3-mbstring \
php7.3-xml \
php7.3-apcu-bc \
php-cas \
php7.3-intl \
php7.3-zip \
php7.3-bz2 \
cron \
wget \
ca-certificates \
&& rm -rf /var/lib/apt/lists/*

RUN wget -P /var/www/html/ "https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz"
RUN tar -xzf "/var/www/html/glpi-${GLPI_VERSION}.tgz" -C /var/www/html/
RUN rm "/var/www/html/glpi-${GLPI_VERSION}.tgz"
RUN chown -R www-data:www-data /var/www/html/glpi

COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite && service apache2 restart && service apache2 stop

RUN rm /var/www/html/glpi/plugins/remove.txt
RUN wget -P /var/www/html/glpi/plugins "${FUSION_INVENTORY_PATH}"
RUN tar -xvf "/var/www/html/glpi/plugins/${FUSION_INVENTORY_TGZ}" -C /var/www/html/glpi/plugins/
RUN chown -R www-data:www-data /var/www/html/glpi/plugins

RUN echo "* * * * * /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" > /etc/crontab
RUN service cron start

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80
EXPOSE 62354