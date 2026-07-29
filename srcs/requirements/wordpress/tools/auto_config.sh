#!/bin/sh

# wait que MariaDB soit lancé et ready
echo "=== En attente de MariaDB... ==="
while ! mariadb-admin ping -h"mariadb" --silent; do
    sleep 2
done
echo "=== MariaDB est prêt ! ==="

# On va ds le doss htlm de wordpress 
cd /var/www/html

# Récupération des secrets 
if [ -f "/run/secrets/db_password" ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi
if [ -f "/run/secrets/wp_admin_password" ]; then
    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
fi
if [ -f "/run/secrets/wp_user_password" ]; then
    WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
fi

# ddl les fichiers de WordPress
if [ ! -f "wp-config.php" ]; then

    echo "=== Téléchargement de WordPress ==="
    wp core download --allow-root

    echo "=== Création du fichier wp-config.php ==="
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --allow-root

    echo "=== Installation de WordPress et création de l'Admin ==="
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    echo "=== Création du deuxieme utilisateur  ==="
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root

fi

echo "=== Démarrage de PHP-FPM sur le port 9000 ==="
# Lance PHP-FPM au premier plan (-F)
exec php-fpm8.2 -F


# Outil WP-CLI ( wp) pour ddl la derniere version de wordpress
# normalement wp-cli refuse par defaut d etre execute en root 
# comme on est ds un conteneur d'init en root, on va forcer avec le flag
# on creer le fichier de config php avec les id de base 
# pour le host on indique a wordpress ou se trouve le server SQL ( mariadb)
# nom du service docker compose + le port standard 

# php-fpm8.2 devient le processus principal  du conteneur ( gestion PID 1)
# provient directement de l instal de debian ds le dockerfile
# -F = foreground ( donc premier plan )  sinon le conteneur se termine car le processus principal est terminé
# ne pas confondre avec -f qui est file ( pour check si fichier existe ) ou -d pour directory 

# Donc innstallation automatisee par le script auto config 
# verif d'abprd di ca existe, sinon utilise wp-cli pour ddl 
# cree le foichier config.php et le connecte au contenmeur mariadb:3306
# configuration du site, admin et user 
# puis passe la main a php-fpm8.2 pour qu'il reste en premier plan

# While do done 
# Le sujet interdit de garder un conteneur en vie artificiellement avec 
# while true ou sleep infinity comme commande finale.
# ICI test d'attente temporaire : il fait un ping sur MariaDB et s'arrête dès que la base répond
# Une fois la configuration terminée, mon script passe la main à php-fpm8.2 -F 
# via exec, qui devient le vrai processus principal.