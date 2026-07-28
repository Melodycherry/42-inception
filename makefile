NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/mlaffita/data

all: up

# cree les doss demandes et lance docker compose en mode detache avec rebuild auto
up:
	mkdir -p $(DATA_DIR)/wordpress
	mkdir -p $(DATA_DIR)/mariadb
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

clean: down
	docker system prune -f

fclean: clean
	sudo rm -rf $(DATA_DIR)/wordpress/*
	sudo rm -rf $(DATA_DIR)/mariadb/*
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all up down clean fclean re

# on lance le mode detache car les conteneurs vont tourner en arriere plan
# le terminal rend la main des que les conteneurs sont demarres, et tahce de fond autonome 
# avec --build force docker a reconstruire les images a partir des dockerfiles avant de lancer conteneurs
# sans --build si on fait des modif ca sera pas pris en compte, docker va utiliser l image deja la 
# docker system prune : Supprime toutes les ressources Docker inutilisées/orphelines
# 2>/dev/null : Redirige les messages d'erreur (le flux 2) vers la poubelle Linux (/dev/null)
# || true meme si echoue, considere que true sinon makefile va s arreter si erreur 