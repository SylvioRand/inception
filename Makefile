COMPOSE   = docker compose -f srcs/docker-compose.yml
LOGIN     = srandria
DATA_DIR  = /home/$(LOGIN)/data/mariadb
WP_DIR    = /home/$(LOGIN)/data/wordpress
REDIS_DIR = /home/$(LOGIN)/data/redis
PORTAINER_DIR = /home/$(LOGIN)/data/portainer

all: init build up

init:
	@echo "Checking required directories..."
	@mkdir -p $(DATA_DIR)      && echo "Created: $(DATA_DIR)" || echo "Exists: $(DATA_DIR)"
	@mkdir -p $(WP_DIR)        && echo "Created: $(WP_DIR)" || echo "Exists: $(WP_DIR)"
	@mkdir -p $(REDIS_DIR)     && echo "Created: $(REDIS_DIR)" || echo "Exists: $(REDIS_DIR)"
	@mkdir -p $(PORTAINER_DIR) && echo "Created: $(PORTAINER_DIR)" || echo "Exists: $(PORTAINER_DIR)"

build:
	@echo "Building containers..."
	@$(COMPOSE) build

up:
	@echo "Starting containers..."
	@$(COMPOSE) up -d

down:
	@echo "Stopping containers..."
	@$(COMPOSE) down

clean: down
	@echo "Removing volumes and orphans..."
	@$(COMPOSE) down --volumes --remove-orphans

fclean: clean
	@echo "Removing all Docker images from docker-compose..."
	@IMAGES=$$(docker images -q); \
	if [ -n "$$IMAGES" ]; then \
		docker rmi -f $$IMAGES || true; \
	else \
		echo "No images to remove."; \
	fi

re: fclean all

.PHONY: all init build up down clean fclean re

