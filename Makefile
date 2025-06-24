LOGIN = ppuivif

TPUT = tput -T xterm-256color
_RED = $(shell $(TPUT) setaf 1)
_RESET = $(shell $(TPUT) sgr0)

all: up

up:
	@mkdir -p /home/$(LOGIN)/data
	@mkdir -p /home/$(LOGIN)/data/mariadb
	@mkdir -p /home/$(LOGIN)/data/wordpress
	@docker compose -f ./srcs/docker-compose.yml up --build -d

down:
	@docker compose -f ./srcs/docker-compose.yml down

clean:
	@docker compose -f ./srcs/docker-compose.yml down --remove-orphans
#	@rm -rf /home/$(LOGIN)/data

fclean: clean
	@docker compose -f ./srcs/docker-compose.yml down -v
	@docker system prune -af

prune:
	@echo "$(_RED)WARNING : Global cleanup of the Docker system (including removal of orphan volumes)...$(_RESET)"
	@docker system prune -af -v

re: fclean all

.PHONY: all up down clean fclean prune re