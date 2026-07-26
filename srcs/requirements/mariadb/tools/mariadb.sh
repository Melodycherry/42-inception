#!/bin/sh

# on creer les dossiers systeme + les droits 
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Init la base ds le volume
if [ ! -d "/var/lib/mysql/wordpress" ]; then

    # Récupération des secrets
    if [ -f "/run/secrets/db_password" ]; then
        MYSQL_PASSWORD=$(cat /run/secrets/db_password)
    fi
    if [ -f "/run/secrets/db_root_password" ]; then
        MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
    fi

    echo "=== Init de la base MariaDB ==="

    # Création d'un fichier SQL temporaire avec les instructions de config
    cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Démarrage de MariaDB avec le fichier d'init
    exec mysqld_safe --datadir=/var/lib/mysql --init-file=/tmp/init.sql

else
    echo "=== Base de données déjà existante ==="
    # Démarrage normal au premier plan (PID 1)
    exec mysqld_safe --datadir=/var/lib/mysql
fi

# Flag -p ( parent) 
# Flag -R ( recursif pour tout le contenu du dossier, sous dossier et fichiers cachés)
# --datadir= indique a quel endroit physique doit save la base de donnee 
# par defaut sous debian c'est /var/lib/mysql

# mysql:mysql = Utilisateur mysql : Groupe mysql
# le systeme va creer un utilisateur systeme mysql. Il doit donc etre proprio des dossiers ou il ecrit

# MariaDB est un systeme de gestion de base de donnees
# Ne comprend que son propre language = SQL (Structured Query Language)
# Pour config au demarrage on va ecrire toutes les commandes ds un fichier brut.sql
# Donc tte les commandes vont etre executees au demarrage

# fi permet de fermer la condition ( if - fi )

# POur le demnarrage --init-file=/tmp/init.sql
# demarre le srveur de base de donnee
# Execute les commande SQL du fichier init
# Puis ensuite demarre le serveur normalement

# Le conteneur ne vit que si son processus principal ( PID 1) est actif 
# pour qu un conteneur reste en UP, la derniere commande du script doit garder le controle du terminal
# exec = remplace le processus actuel par le nouveau processus mysqld_safe

# explication des ordres SQL ds le fichier d'init :
# FLUSH PRIVILEGES; = recharge les droits d acces a la base de donnee ( base clean )
# repart sur une mémoire propre avant d'ajouter les utilisateurs
# CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`; = cree la base de donnee
# CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; = cree l utilisateur
# GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%'; = donne tous les droits
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; = mot de passe root
# FLUSH PRIVILEGES; = les modif sont ecrites sur le disc, valide tous les nouveaux droits
# = Force la mise à jour immédiate de ta mémoire RAM avec les nouveaux utilisateurs qu'on vient de créer 

# POur mysqld_safe il est installé automatiquement avec mariadb. 
# Il permet de lancer le serveur mariadb et de le relancer si il crash
# safe parceque c'est un wrapper officiel fourni par mnariadb 
# si le serveur crash, il va le relancer automatiquement


