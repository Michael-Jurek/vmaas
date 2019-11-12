VOLUME_DIR = $(HOME)/.local/share/containers/storage/volumes/vmaas_vmaas-db-data

.PHONY: up
up:
	sudo podman-compose down
	rm -rf $(VOLUME_DIR) || (echo "Failed to remove folder $$?"; exit 0)
	sudo podman-compose up --build

down:
	sudo podman-compose down

ps:
	sudo podman ps -a

webapp:
	sudo podman exec -it vmaas-webapp bash

webapp_utils:
	sudo podman exec -it vmaas-webap-utils bash

database:
	sudo podman exec -it vmaas-database bash

reposcan:
	sudo podman exec -it vmaas-reposcan bash

websocket:
	sudo podman exec -it vmaas-websocket bash
