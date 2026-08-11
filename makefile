NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml

all: prepare
	docker compose -f $(COMPOSE_FILE) up -d --build

prepare:
	@mkdir -p /home/mlaffita/data/wordpress
	@mkdir -p /home/mlaffita/data/mariadb

down:
	docker compose -f $(COMPOSE_FILE) down

clean: down
	@sudo rm -rf /home/mlaffita/data/wordpress/*
	@sudo rm -rf /home/mlaffita/data/mariadb/*

fclean: clean
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -a --volumes -f
	@sudo rm -rf /home/mlaffita/data

re: fclean all

.PHONY: all prepare down clean fclean re


# -d (Mode détaché) : Les conteneurs tournent en arrière-plan. Le terminal rend 
#  la main dès que les conteneurs sont démarrés, les laissant autonomes.
#
# --build : Force Docker à reconstruire les images à partir des Dockerfiles 
#  avant de lancer les conteneurs. Sans cela, si on modifie un script ou un fichier 
#  de conf, Docker réutiliserait l'ancienne image en cache sans prendre en compte nos changements
#
# down -v : Stoppe les conteneurs et SUPPRIME les volumes nommés (-v).
#
# docker system prune -a --volumes -f : Nettoie tout le système Docker : 
# toutes les images non utilisées (-a), tous les volumes (-volumes) sans confirmation (-f).