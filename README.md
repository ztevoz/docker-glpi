# GLPI avec Fusion inventory, Behaviours et PDF pré-téléchargés

date mise à l'heure FR et cron configuré pour GLPI

https://hub.docker.com/r/ztevoz/glpi

## Exemple simple

$docker run --name glpi-db  -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=glpi -e MYSQL_USER=glpi -e MYSQL_PASSWORD=glpi --volume glpi-db:/var/lib/mysql  -d mariadb

$docker run --name glpi --link glpi-db:db --volume glpi-data:/var/www/html/glpi/files/ -p 81:80 -d ztevoz/glpi

## Post Install

pour nettoyer le fichier d'installation

$docker exec glpi rm /var/www/html/glpi/install/install.php

Si problèmes de cron avec le module fusion-inventory, redmerrare le container apres l'installation du plugin ou 

$docker exec <container_name> service cron restart

## Docker-Compose

se placer dans le dossier où se trouve docker-compose.yml

docker-compose up -d

ou si le fichier est ailleurs, rajouter l'option -f suivie du chemin vers le fichier compose

## Pour builder l'image en local

commcer par cloner le depot avec git clone

puis

$docker build --rm -t ztevoz/glpi .