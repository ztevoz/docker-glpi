#docker build --rm -t ztevoz/glpi .
FROM debian:10.4

#V1

LABEL maintainer="ZtevOz Milloz"

ENV DEBIAN_FRONTEND noninteractive
ARG GLPI_VERSION=9.5.1

ARG FUSION_INVENTORY_PATH="https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi9.5.0%2B1.0/fusioninventory-9.5.0+1.0.tar.bz2"
ARG FUSION_INVENTORY_TGZ="fusioninventory-9.5.0+1.0.tar.bz2"

ARG BEHAVIOURS_PATH="https://forge.glpi-project.org/attachments/download/2316/glpi-behaviors-2.4.1.tar.gz"
ARG BEHAVIOURS_TGZ="glpi-behaviors-2.4.1.tar.gz"

ARG PDF_PATH="https://forge.glpi-project.org/attachments/download/2314/glpi-pdf-1.7.0.tar.gz"
ARG PDF_TGZ="glpi-pdf-1.7.0.tar.gz"

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
vim \
ca-certificates \
tzdata \
&& ln -snf /usr/share/zoneinfo/Europe/Paris /etc/localtime \
&& dpkg-reconfigure -f noninteractive tzdata \
&& rm -rf /var/lib/apt/lists/*

RUN wget -P /var/www/html/ "https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz"
RUN tar -xzf "/var/www/html/glpi-${GLPI_VERSION}.tgz" -C /var/www/html/
RUN rm "/var/www/html/glpi-${GLPI_VERSION}.tgz"
RUN chown -R www-data:www-data /var/www/html/glpi

COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite && service apache2 restart && service apache2 stop

RUN rm /var/www/html/glpi/plugins/remove.txt

RUN wget -P /var/www/html/glpi/plugins "${BEHAVIOURS_PATH}"
RUN tar -xvf "/var/www/html/glpi/plugins/${BEHAVIOURS_TGZ}" -C /var/www/html/glpi/plugins/

RUN wget -P /var/www/html/glpi/plugins "${FUSION_INVENTORY_PATH}"
RUN tar -xvf "/var/www/html/glpi/plugins/${FUSION_INVENTORY_TGZ}" -C /var/www/html/glpi/plugins/

RUN wget -P /var/www/html/glpi/plugins "${PDF_PATH}"
RUN tar -xvf "/var/www/html/glpi/plugins/${PDF_TGZ}" -C /var/www/html/glpi/plugins/

RUN chown -R www-data:www-data /var/www/html/glpi/plugins

RUN echo "* * * * * root /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" > /etc/crontab

VOLUME ["/var/www/html/glpi/files/", "/var/www/html/glpi/config/"]

COPY ./startup.sh /bin/startup.sh
RUN chmod +x /bin/startup.sh
ENTRYPOINT ["/bin/startup.sh"]

EXPOSE 80
