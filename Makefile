NAME     = inception
COMPOSE  = docker compose -f srcs/docker-compose.yml
LOGIN    = srandria
DATA_DIR = /home/$(LOGIN)/data/mariadb
WP_DIR   = /home/$(LOGIN)/data/wordpress

all: init build up

init:
	@echo "Checking $(DATA_DIR) and $(WP_DIR) directories..."
	@if [ ! -d $(DATA_DIR) ]; then \
		echo "Creating $(DATA_DIR)\n"; \
		mkdir -p $(DATA_DIR); else \
		echo "$(DATA_DIR) already exists.\n"; \
	fi
	@if [ ! -d $(WP_DIR) ]; then \
		echo "Creating $(WP_DIR)\n"; \
		mkdir -p $(WP_DIR); else \
		echo "$(WP_DIR) already exists.\n"; \
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
