pNAME     = inception
COMPOSE  = docker compose -f srcs/docker-compose.yml
LOGIN    = srandria
DATA_DIR = /home/$(LOGIN)/data/mariadb
WP_DIR   = /home/$(LOGIN)/data/wordpress
REDIS_DIR = /home/srandria/data/redis
PORTAINER_DIR = /home/srandria/data/portainer

all: init build up

init:
	@echo "Checking $(DATA_DIR), $(WP_DIR), ${REDIS_DIR} and ${PORTAINER_DIR} directories..."
	@if [ ! -d $(DATA_DIR) ]; then \
		echo "Creating $(DATA_DIR)\n"; \
		mkdir -p $(DATA_DIR); \
	else \
		echo "$(DATA_DIR) already exists.\n"; \
	fi
	@if [ ! -d $(WP_DIR) ]; then \
		echo "Creating $(WP_DIR)\n"; \
		mkdir -p $(WP_DIR); \
	else \
		echo "$(WP_DIR) already exists.\n"; \
	fi
	@if [ ! -d $(REDIS_DIR) ]; then \
		echo "Creating $(REDIS_DIR)\n"; \
		mkdir -p $(REDIS_DIR); \
	else \
		echo "$(REDIS_DIR) already exists.\n"; \
	fi
	@if [ ! -d $(PORTAINER_DIR) ]; then \
		echo "Creating $(PORTAINER_DIR)\n"; \
		mkdir -p $(PORTAINER_DIR); \
	else \
		echo "$(PORTAINER_DIR) already exists.\n"; \
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
	@IMAGES=$$(docker images -q $(NAME)_*); \
	if [ -n "$$IMAGES" ]; then \
		docker rmi -f $$IMAGES; \
	else \
		echo "No images to remove."; \
	fi


re: fclean all

.PHONY: all init build up down clean fclean re
