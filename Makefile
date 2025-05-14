# Variables
NAME     = inception
COMPOSE  = docker compose -f srcs/docker-compose.yml
LOGIN    = srandria
DATA_DIR = $(LOGIN)/data/mariadb

# Règles principales
all: init build up

init:
	@echo "Vérification du dossier $(DATA_DIR)..."
	@if [ ! -d $(DATA_DIR) ]; then \
		echo "Création de $(DATA_DIR)"; \
		mkdir -p $(DATA_DIR); \
	else \
		echo "$(DATA_DIR) existe déjà."; \
	fi

build:
	@echo "Building containers from Dockerfiles..."
	$(COMPOSE) build

up:
	@echo "Starting containers..."
	$(COMPOSE) up -d

down:
	@echo "Stopping containers..."
	$(COMPOSE) down

clean: down
	@echo "Cleaning containers, networks and volumes..."
	$(COMPOSE) down --volumes --remove-orphans

fclean: clean
	@echo "Removing Docker images..."
	docker rmi -f $$(docker images -q $(NAME)_*)

re: fclean all

.PHONY: all init build up down clean fclean re

