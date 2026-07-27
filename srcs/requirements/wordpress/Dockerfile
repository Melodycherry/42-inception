FROM debian:bookworm

# ajout pour jamais afficher de fenetre d interaction pdt l install ( evite de bliquer sur question de config )
ENV DEBIAN_FRONTEND=noninteractive

# Installation de PHP-FPM, des extensions requises par WordPress, de curl et mariadb-client
RUN apt-get update && apt-get install -y --no-install-recommends \
    php8.2-fpm \
    php8.2-mysqli \
    php8.2-curl \
    php8.2-dom \
    php8.2-exif \
    php8.2-fileinfo \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    wget \
    mariadb-client \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Téléchargement et installation de WP-CLI (Command Line Interface pour WordPress)
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Création du dossier du site web et des dossiers de run PHP
RUN mkdir -p /var/www/html /run/php \
    && chown -R www-data:www-data /var/www/html /run/php

# Copie de la configuration PHP-FPM et du script
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh

# Pour rendre le script executable par le systeme 
RUN chmod +x /usr/local/bin/auto_config.sh

# Indique que ce conteneur écoutera les requêtes réseau FastCGI venant de NGINX sur le port 9000
EXPOSE 9000

# Lancement du script
ENTRYPOINT ["/usr/local/bin/auto_config.sh"]


# faire tourner le code php de wordrpress
# contient instal de php-fpm, les extensions php
# l'outil wp-cli pour ddl et installer wordpress ( port 9000)

# Pas serveur web ici, execute uniquement PHP FPM sur le port 9000 ecoute requetes envoyees pqr nginx
# WP-CLI = wordpress commande line interface 
# ca va pernettre d automatiser via le script shell

# Les install :
# - php-fpm8.2 : va executer les fichiers php du site
# - php8.2-mysqli : extension pour se connecter a la base de donnees mariadb
# - php8.2-... : extensions requises pour image, zip, texte, encodage ...
# wget : pour ddl wordpress et wp-cli
# mariadb-client : pour se connecter a la base de donnees mariadb 
# le non install + rm etc ... = evite intall de paquet superflus et nettoient le cache local
