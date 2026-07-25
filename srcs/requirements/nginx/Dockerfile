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

# -x509 : va generer le certificat auto-signe
# -nodes : pas de mot de passe pour la cle privee
# -days 365 : valide pour 365 jours
# -newkey rsa:2048 : genere une nouvelle cle privee de 2048 bits
# -subj : defini les info du certificat ( pays, etat, ville, organisation, unite, nom commun )
# CN = common name, donc nom de domaine 