TPUT = tput -T xterm-256color
_RED = $(shell $(TPUT) setaf 1)
_RESET = $(shell $(TPUT) sgr0)

all: up

up:
	@docker compose up --build -d

down:
	@docker compose down

clean:
	@docker compose down --remove-orphans

fclean: clean
	@docker compose down -v
	@docker system prune -af

prune:
	@echo "$(_RED)WARNING : Global cleanup of the Docker system (including removal of orphan volumes)...$(_RESET)"
	@docker system prune -af -v

re: fclean all

.PHONY: all up down clean fclean prune re
