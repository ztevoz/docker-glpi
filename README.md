# GLPI avec Fusion inventory

https://hub.docker.com/r/ztevoz/glpi

## Exemple


$docker run --name glpi-db  -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=glpi -e MYSQL_USER=glpi -e MYSQL_PASSWORD=glpi --volume glpi-db:/var/lib/mysql  -d mariadb

$docker run --name glpi --link glpi-db:db --volume glpi-data:/var/www/html/glpi/files/ -p 81:80 -p 62354:62354  -d ztevoz/glpi

## Docker-Compose