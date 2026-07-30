FROM debian:bookworm

# installation des logiciels et dependance
# Un seul run pour update + install + cleanup ( sinon ca va creer un layer de plus )
RUN apt-get update && apt-get install -y --no-install-recommends \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

#Pour generer les certificats SSL
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/inception.key \
		-out /etc/nginx/ssl/inception.crt \
		-subj "/C=CH/ST=Vaud/L=Lausanne/O=42/OU=42/CN=mlaffita.42.fr"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# pour eviter conflit avec le fichier de config par defaut de nginx, on le supprime
RUN rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

EXPOSE 443 

CMD ["nginx", "-g", "daemon off;"]

# serveur web securisé
# contient installation nginx, openssl ?? 
# copie du fichier de config nginx
# generation des cles SSL pour HTTPS ( port 443 ?? )

# && rm -rf /var/lib/apt/lists/* va supp le cache de la liste des paquets
# optimise l'espace disque 

# l'outil openssl va generer la paire cle/ certif  
# SSL = Secure Sockets Layer
# Securisation des communications sur internet
# On cree un dossier poru stocker le certif et la cle privee

# commande req = pour generer un certificat 
# -x509 : va generer le certificat auto-signe
# -nodes : pas de mot de passe pour la cle privee
# -out : nom du fichier de sortie pour le certificat et ou il sera stocke
# -keyout : nom du fichier de sortie pour la cle privee et ou il sera stocke
# -days 365 : valide pour 365 jours
# -newkey rsa:2048 : genere une nouvelle cle privee de 2048 bits
# -subj : defini les info du certificat ( pays, etat, ville, organisation, unite, nom commun )
# CN = common name, donc nom de domaine 

# -g : directive globale (ne modif pas le fichier de config principale)
# daemon off force nginx a garder le control du processus principal 

# pour la COPY :
#  /etc/nginx/nginx.conf est la config globale de NGINX ( pas toucher )
# /etc/nginx/conf.d/ est le doss ou on va mettre la config de notre site web
# on remplace pas le config globale de nginx, sinon va plus avoir acces aux directives globales
