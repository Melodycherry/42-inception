FROM debian:bookworm

# installation des logiciels et dependance
RUN apt-get update && apt-get install -y \
	mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

# Création du dossier nécessaire pour le socket MariaDB avec les bons droits
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/mariadb.conf
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

# droit d execution
RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

# commande au lancement du container ( on lance le script)
ENTRYPOINT ["/usr/local/bin/mariadb.sh"]



# le docker de maria db va creer la base de donnée
# doit contenir l'install de mariadb server, la config pour ouvrir le bon port
# et script pour creer utilistauers de la base de données
