build:
	# podman builds all vmaas images
	sudo podman build -t vmaas/database:latest -f $(CURDIR)/database/Dockerfile .
	sudo podman build -t vmaas/websocket:latest -f $(CURDIR)/websocket/Dockerfile .
	sudo podman build -t vmaas/reposcan:latest -f $(CURDIR)/reposcan/Dockerfile .
	sudo podman build -t vmaas/webapp:latest -f $(CURDIR)/webapp/Dockerfile .
	sudo podman build -t vmaas/apidoc:latest -f $(CURDIR)/Dockerfile-apidoc .
	sudo podman build -t vmaas/webapp_utils:latest -f $(CURDIR)/webapp_utils/Dockerfile .

	# podman build -t vmaas_webapp -f $(CURDIR)/webapp
	# podman build -t vmaas_webapp_utils -f $(CURDIR)/webapp_utils
	# podman build -t vmaas_reposcan -f $(CURDIR)/reposcan
	# podman build -t vmaas_websocket -f $(CURDIR)/websocket
	# podman build -t vmaas_database -f $(CURDIR)/database
	# podman build -t vmaas_apidoc -f ./Dockerfile-apidoc

up:
	# podman creates a new container from the given image and runs it
	sudo podman pod create --name=vmaas --share net -p 8081:8081 -p 8730:8730 -p 8083:8083 -p 8080:8080 -p 5432:5432 -p 8000:8080 -p 8082:8082 -p 3000:3000 -p 9090:9090
	sudo podman volume inspect vmaas_vmaas-db-data || sudo podman volume create vmaas_vmaas-db-data
	sudo podman create --name=vmaas-database --pod=vmaas -l io.podman.compose.config-hash=123 -l io.podman.compose.project=vmaas -l io.podman.compose.version=0.0.1 -l com.docker.compose.container-number=1 -l com.docker.compose.service=vmaas_database --env-file ./conf/database-connection-admin.env --mount type=bind,source=/var/lib/containers/storage/volumes/vmaas_vmaas-db-data/_data,destination=/var/lib/pgsql/11/data,bind-propagation=Z --add-host vmaas_database:127.0.0.1 --add-host vmaas-database:127.0.0.1 --add-host vmaas_websocket:127.0.0.1 --add-host vmaas-websocket:127.0.0.1 --add-host vmaas_reposcan:127.0.0.1 --add-host vmaas-reposcan:127.0.0.1 --add-host vmaas_webapp:127.0.0.1 --add-host vmaas-webapp:127.0.0.1 --add-host vmaas_apidoc:127.0.0.1 --add-host vmaas-apidoc:127.0.0.1 --add-host vmaas_webapp_utils:127.0.0.1 --add-host vmaas-webapp-utils:127.0.0.1 --add-host vmaas_prometheus:127.0.0.1 --add-host vmaas-prometheus:127.0.0.1 --add-host vmaas_grafana:127.0.0.1 --add-host vmaas-grafana:127.0.0.1 vmaas/database:latest
	sudo podman create --name=vmaas-websocket --pod=vmaas -l io.podman.compose.config-hash=123 -l io.podman.compose.project=vmaas -l io.podman.compose.version=0.0.1 -l com.docker.compose.container-number=1 -l com.docker.compose.service=vmaas_websocket --add-host vmaas_database:127.0.0.1 --add-host vmaas-database:127.0.0.1 --add-host vmaas_websocket:127.0.0.1 --add-host vmaas-websocket:127.0.0.1 --add-host vmaas_reposcan:127.0.0.1 --add-host vmaas-reposcan:127.0.0.1 --add-host vmaas_webapp:127.0.0.1 --add-host vmaas-webapp:127.0.0.1 --add-host vmaas_apidoc:127.0.0.1 --add-host vmaas-apidoc:127.0.0.1 --add-host vmaas_webapp_utils:127.0.0.1 --add-host vmaas-webapp-utils:127.0.0.1 --add-host vmaas_prometheus:127.0.0.1 --add-host vmaas-prometheus:127.0.0.1 --add-host vmaas_grafana:127.0.0.1 --add-host vmaas-grafana:127.0.0.1 vmaas/websocket:latest
	sudo podman volume inspect vmaas_vmaas-reposcan-tmp || sudo podman volume create vmaas_vmaas-reposcan-tmp
	sudo podman volume inspect vmaas_vmaas-dump-data || sudo podman volume create vmaas_vmaas-dump-data
	sudo podman create --name=vmaas-reposcan --pod=vmaas -l io.podman.compose.config-hash=123 -l io.podman.compose.project=vmaas -l io.podman.compose.version=0.0.1 -l com.docker.compose.container-number=1 -l com.docker.compose.service=vmaas_reposcan --env-file ./conf/database-connection-writer.env --env-file ./conf/reposcan.env --mount type=bind,source=/var/lib/containers/storage/volumes/vmaas_vmaas-reposcan-tmp/_data,destination=/tmp,bind-propagation=Z --mount type=bind,source=/var/lib/containers/storage/volumes/vmaas_vmaas-dump-data/_data,destination=/data,bind-propagation=z --add-host vmaas_database:127.0.0.1 --add-host vmaas-database:127.0.0.1 --add-host vmaas_websocket:127.0.0.1 --add-host vmaas-websocket:127.0.0.1 --add-host vmaas_reposcan:127.0.0.1 --add-host vmaas-reposcan:127.0.0.1 --add-host vmaas_webapp:127.0.0.1 --add-host vmaas-webapp:127.0.0.1 --add-host vmaas_apidoc:127.0.0.1 --add-host vmaas-apidoc:127.0.0.1 --add-host vmaas_webapp_utils:127.0.0.1 --add-host vmaas-webapp-utils:127.0.0.1 --add-host vmaas_prometheus:127.0.0.1 --add-host vmaas-prometheus:127.0.0.1 --add-host vmaas_grafana:127.0.0.1 --add-host vmaas-grafana:127.0.0.1 vmaas/reposcan:latest
	sudo podman create --name=vmaas-webapp --pod=vmaas -l io.podman.compose.config-hash=123 -l io.podman.compose.project=vmaas -l io.podman.compose.version=0.0.1 -l com.docker.compose.container-number=1 -l com.docker.compose.service=vmaas_webapp --env-file ./conf/webapp.env --add-host vmaas_database:127.0.0.1 --add-host vmaas-database:127.0.0.1 --add-host vmaas_websocket:127.0.0.1 --add-host vmaas-websocket:127.0.0.1 --add-host vmaas_reposcan:127.0.0.1 --add-host vmaas-reposcan:127.0.0.1 --add-host vmaas_webapp:127.0.0.1 --add-host vmaas-webapp:127.0.0.1 --add-host vmaas_apidoc:127.0.0.1 --add-host vmaas-apidoc:127.0.0.1 --add-host vmaas_webapp_utils:127.0.0.1 --add-host vmaas-webapp-utils:127.0.0.1 --add-host vmaas_prometheus:127.0.0.1 --add-host vmaas-prometheus:127.0.0.1 --add-host vmaas_grafana:127.0.0.1 --add-host vmaas-grafana:127.0.0.1 vmaas/webapp:latest
	sudo podman create --name=vmaas-webapp-utils --pod=vmaas -l io.podman.compose.config-hash=123 -l io.podman.compose.project=vmaas -l io.podman.compose.version=0.0.1 -l com.docker.compose.container-number=1 -l com.docker.compose.service=vmaas_webapp_utils --env-file ./conf/webapp_utils.env --env-file ./conf/database-connection-reader.env --add-host vmaas_database:127.0.0.1 --add-host vmaas-database:127.0.0.1 --add-host vmaas_websocket:127.0.0.1 --add-host vmaas-websocket:127.0.0.1 --add-host vmaas_reposcan:127.0.0.1 --add-host vmaas-reposcan:127.0.0.1 --add-host vmaas_webapp:127.0.0.1 --add-host vmaas-webapp:127.0.0.1 --add-host vmaas_apidoc:127.0.0.1 --add-host vmaas-apidoc:127.0.0.1 --add-host vmaas_webapp_utils:127.0.0.1 --add-host vmaas-webapp-utils:127.0.0.1 --add-host vmaas_prometheus:127.0.0.1 --add-host vmaas-prometheus:127.0.0.1 --add-host vmaas_grafana:127.0.0.1 --add-host vmaas-grafana:127.0.0.1 vmaas/webapp_utils:latest
	sudo podman volume inspect vmaas_prometheus-data || sudo podman volume create vmaas_prometheus-data
	sudo podman create --name=vmaas-prometheus --pod=vmaas --security-opt label=disable -l io.podman.compose.config-hash=123 -l io.podman.compose.project=vmaas -l io.podman.compose.version=0.0.1 -l com.docker.compose.container-number=1 -l com.docker.compose.service=vmaas_prometheus --mount type=bind,source=/var/lib/containers/storage/volumes/vmaas_prometheus-data/_data,destination=/prometheus,bind-propagation=Z --mount type=bind,source=./monitoring/prometheus/prometheus.yml,destination=/etc/prometheus/prometheus.yml --add-host vmaas_database:127.0.0.1 --add-host vmaas-database:127.0.0.1 --add-host vmaas_websocket:127.0.0.1 --add-host vmaas-websocket:127.0.0.1 --add-host vmaas_reposcan:127.0.0.1 --add-host vmaas-reposcan:127.0.0.1 --add-host vmaas_webapp:127.0.0.1 --add-host vmaas-webapp:127.0.0.1 --add-host vmaas_apidoc:127.0.0.1 --add-host vmaas-apidoc:127.0.0.1 --add-host vmaas_webapp_utils:127.0.0.1 --add-host vmaas-webapp-utils:127.0.0.1 --add-host vmaas_prometheus:127.0.0.1 --add-host vmaas-prometheus:127.0.0.1 --add-host vmaas_grafana:127.0.0.1 --add-host vmaas-grafana:127.0.0.1 prom/prometheus:v2.1.0 --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus --web.console.libraries=/usr/share/prometheus/console_libraries --web.console.templates=/usr/share/prometheus/consoles
	sudo podman create --name=vmaas-apidoc --pod=vmaas -l io.podman.compose.config-hash=123 -l io.podman.compose.project=vmaas -l io.podman.compose.version=0.0.1 -l com.docker.compose.container-number=1 -l com.docker.compose.service=vmaas_apidoc --env-file ./conf/apidoc.env --add-host vmaas_database:127.0.0.1 --add-host vmaas-database:127.0.0.1 --add-host vmaas_websocket:127.0.0.1 --add-host vmaas-websocket:127.0.0.1 --add-host vmaas_reposcan:127.0.0.1 --add-host vmaas-reposcan:127.0.0.1 --add-host vmaas_webapp:127.0.0.1 --add-host vmaas-webapp:127.0.0.1 --add-host vmaas_apidoc:127.0.0.1 --add-host vmaas-apidoc:127.0.0.1 --add-host vmaas_webapp_utils:127.0.0.1 --add-host vmaas-webapp-utils:127.0.0.1 --add-host vmaas_prometheus:127.0.0.1 --add-host vmaas-prometheus:127.0.0.1 --add-host vmaas_grafana:127.0.0.1 --add-host vmaas-grafana:127.0.0.1 vmaas/apidoc:latest
	sudo podman volume inspect vmaas_grafana-data || sudo podman volume create vmaas_grafana-data 
	sudo podman create --name=vmaas-grafana --pod=vmaas -l io.podman.compose.config-hash=123 -l io.podman.compose.project=vmaas -l io.podman.compose.version=0.0.1 -l com.docker.compose.container-number=1 -l com.docker.compose.service=vmaas_grafana --env-file ./monitoring/grafana/grafana.conf --mount type=bind,source=/var/lib/containers/storage/volumes/vmaas_grafana-data/_data,destination=/var/lib/grafana,bind-propagation=Z --mount type=bind,source=./monitoring/grafana/provisioning/,destination=/etc/grafana/provisioning/ --add-host vmaas_database:127.0.0.1 --add-host vmaas-database:127.0.0.1 --add-host vmaas_websocket:127.0.0.1 --add-host vmaas-websocket:127.0.0.1 --add-host vmaas_reposcan:127.0.0.1 --add-host vmaas-reposcan:127.0.0.1 --add-host vmaas_webapp:127.0.0.1 --add-host vmaas-webapp:127.0.0.1 --add-host vmaas_apidoc:127.0.0.1 --add-host vmaas-apidoc:127.0.0.1 --add-host vmaas_webapp_utils:127.0.0.1 --add-host vmaas-webapp-utils:127.0.0.1 --add-host vmaas_prometheus:127.0.0.1 --add-host vmaas-prometheus:127.0.0.1 --add-host vmaas_grafana:127.0.0.1 --add-host vmaas-grafana:127.0.0.1 -u 104 grafana/grafana:6.2.5
	sudo podman start vmaas-database
	sudo podman start vmaas-websocket
	sudo podman start vmaas-reposcan
	sudo podman start vmaas-webapp
	sudo podman start vmaas-webapp-utils
	sudo podman start vmaas-prometheus
	sudo podman start vmaas-apidoc
	sudo podman start vmaas-grafana

	#sudo podman run --name websocket -dt --restart=always vmaas/websocket:latest
	#sudo podman run --name webapp -dt --env-file $(CURDIR)/conf/webapp.env --restart=always vmaas/webapp:latest
	#sudo podman run --name reposcan --pod vmaas -dt -v vmaas-reposcan-tmp:/tmp -v vmaas-dump-data:/data:z --env-file $(CURDIR)/conf/database-connection-writer.env --env-file $(CURDIR)/conf/reposcan.env --restart=always vmaas/reposcan:latest
	#sudo podman run --name apidoc --pod vmaas -dt --env-file $(CURDIR)/conf/apidoc.env --restart=always vmaas/apidoc:latest
	#sudo podman run --name database --pod vmaas -dt --env-file $(CURDIR)/conf/database-connection-admin.env -v vmaas-db-data:/var/lib/psql/data --restart=always vmaas/database:latest
	#sudo podman run --name webapp_utils --pod vmaas -dt --env-file $(CURDIR)/conf/webapp_utils.env --restart=always vmaas/webapp_utils:latest
	#sudo podman run --name grafana --pod vmaas -dt --env-file $(CURDIR)/monitoring/grafana/grafana.conf -v grafana-data:/var/lib/grafana -v $(CURDIR)/monitoring/grafana/provisioning/:/etc/grafana/provisioning/ -u 104 --restart=always grafana/grafana:6.2.5
	#sudo podman run --name prometheus --pod vmaas -dt -v prometheus-data:/prometheus -v $(CURDIR)/monitoring/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml --restart=always prom/prometheus:v2.1.0 --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus --web.console.libraries=/usr/share/prometheus/console_libraries --web.console.templates=/usr/share/prometheus/consoles 
	

	# TODO: nahradit -v . pomoci $(CURDIR) + expose vsech portu

	# podman run --name vmaas_webapp --pod vmaas -dt --restart=on-failure:2 vmaas_webapp:latest
	# podman run --name vmaas_websocket --pod vmaas -dt --restart=on-failure:2 vmaas_websocket:latest
	# podman run --name vmaas_reposcan  --pod vmaas -dt --restart=on-failure:2 --expose=8081,8730 vmaas_reposcan:latest
	# podman run --name vmaas_apidoc --pod vmaas -dt --restart=on-failure:2 vmaas_apidoc:latest
	# podman run --name vmaas_webapp_utils --pod vmaas_dev -dt --restart=on-failure:2 --expose=8083 vmaas_webapp_utils:latest
	# podman run --name vmaas_database --pod vmaas_dev -dt --restart=on-failure:2 --expose=5432 vmaas_database:latest
	# podman run --name vmaas_apidoc --pod apidoc -dt --restart=on-failure:2 vmaas_apidoc:latest

logs_webapp:
	# access to container logs
	sudo podman logs vmaas-webapp

logs_webapp_utils:
	sudo podman logs vmaas-webapp-utils

logs_websocket:
	sudo podman logs vmaas-websocket

logs_reposcan:
	sudo podman logs vmaas-reposcan

ps:
	# podman lists running containers in pod
	sudo podman ps -pa

down:
	# podman deletes pod with containers inside
	sudo podman pod rm -f vmaas

start:
	# podman starts given pods
	sudo podman pod start vmaas

stop:
	# podman stops given pods
	sudo podman pod stop vmaas

bash_webapp:
	# podman execs shell in container inside pod
	sudo podman exec -it webapp bash

bash_webapp_utils:
	sudo podman exec -it webapp_utils bash

bash_websocket:
	sudo podman exec -it websocket bash

bash_reposcan:
	sufo podman exec -it reposcan bash

prune:
	sudo podman volume rm -f vmaas-db-data
	sudo podman volume rm -f vmaas-dump-data
	sudo podman volume rm -f vmaas-reposcan-tmp
	sudo podman volume rm -f prometheus-data
	sudo podman volume rm -f grafana-data

end:
	-sudo podman stop --all
	-sudo podman rm --all
	-sudo podman pod rm --all
	-sudo podman volume rm -f --all