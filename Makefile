VOLUME_DIR = $(HOME)/.local/share/containers/storage/volumes/vmaas_vmaas-db-data/
CONTAINER_CONFIG = $(HOME)/.config/containers/storage.conf
# zastavit bezici pod
# smazat slozku _data
# $(shell sed -i 's/^\([ ]*driver[ ]*=[ ]*\).*/\1"btrfs"/' $(CONTAINER_CONFIG))
# chcon -Rt container_file_t $(VOLUME_DIR)

set:
	sudo mkdir /var/vmaas || (echo "Failed to create folder $$?";exit 0)
	sudo chmod -R 755 /var/vmaas || (echo "Failed to change permissions $$?";exit 0)
	sudo chown -R $(USER):$(USER) /var/vmaas || (echo "Failed to change permissions $$?";exit 0)
	sudo chcon -R -t container_file_t /var/vmaas || (echo "Failed to relabel selinux to container_file_t $$?";exit 0)

up: set
	#rm -rf $(VOLUME_DIR)_data || (echo "Failed to remove ~/_data folder $$?";exit 0)
	#podman pod rm vmaas || (echo "Failed to remove vmaas pod $$?";exit 0)
	mkdir /var/vmaas/vmaas-db-data || (echo "Failed to create folder $$?";exit 0)
	sudo chown -R postgres:postgres /var/vmaas/vmaas-db-data || (echo "Failed to change permissions $$?";exit 0)
	mkdir /var/vmaas/vmaas-dump-data || (echo "Failed to create folder $$?";exit 0)
	mkdir /var/vmaas/vmaas-reposcan-tmp || (echo "Failed to create folder $$?";exit 0)
	mkdir /var/vmaas/prometheus-data || (echo "Failed to create folder $$?";exit 0)
	mkdir /var/vmaas/grafana-data || (echo "Failed to create folder $$?";exit 0)
	podman-compose up --build

down:
	podman-compose down

ps:
	podman ps -a

.PHONY: webapp
webapp:
	podman exec -it vmaas-webapp bash

.PHONY: webapp_utils
webapp_utils:
	podman exec -it vmaas-webap-utils bash

.PHONY: database
database:
	podman exec -it vmaas-database bash

.PHONY: reposcan
reposcan:
	podman exec -it vmaas-reposcan bash

.PHONY: websocket
websocket:
	podman exec -it vmaas-websocket bash

devel: