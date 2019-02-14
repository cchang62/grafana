#!/bin/bash

# pre-require docker daemon
# https://docs.docker.com/install/linux/docker-ce/centos/
# https://github.com/NaturalHistoryMuseum/scratchpads2/wiki/Install-Docker-and-Docker-Compose-(Centos-7)
# 
# sudo yum remove docker \
#                 docker-client \
#                 docker-client-latest \
#                 docker-common \
#                 docker-latest \
#                 docker-latest-logrotate \
#                 docker-logrotate \
#                 docker-engine
#
# sudo yum install -y yum-utils \
#                     device-mapper-persistent-data \
#                     lvm2
#
# sudo yum-config-manager \
#   --add-repo \
#   https://download.docker.com/linux/centos/docker-ce.repo
#
# sudo yum install docker-ce
# sudo usermod -aG docker $(whoami)
# sudo systemctl enable docker.service
# sudo systemctl start docker.service

sudo mkdir /opt/monitoring && cd /opt/monitoring

DOCKER_COMPOSE_VERSION="1.23.2"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROXY="http://proxy.abc.com:8080"

sudo curl -x ${PROXY} \
    -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
sudo chmod g+rwx .
sudo chgrp $(whoami) .

# generate docker compose file
cat > ${DIR}/docker-compose.yml <<- EOT
version: "2"
services:
  grafana:
    image: grafana/grafana
    container_name: grafana
    restart: always
    ports:
      - 0.0.0.0:8085:3000
    networks:
      - monitoring
    volumes:
      - grafana-volume:/var/lib/grafana
  influxdb:
    image: influxdb
    container_name: influxdb
    restart: always
    ports:
      - 8086:8086
    networks:
      - monitoring
    volumes:
      - influxdb-volume:/var/lib/influxdb
networks:
  monitoring:
volumes:
  grafana-volume:
    external: true
  influxdb-volume:
    external: true
EOT

# Create docker network and volume
docker network create monitoring
docker volume create grafana-volume
docker volume create influxdb-volume

# Build InfluxDB service container
docker run --rm \
  -e INFLUXDB_DB=telegraf \
  -e INFLUXDB_ADMIN_ENABLED=true \
  -e INFLUXDB_ADMIN_USER=admin \
  -e INFLUXDB_ADMIN_PASSWORD=admin \
  -e INFLUXDB_USER=telegraf \
  -e INFLUXDB_USER_PASSWORD=telegraf \
  -v influxdb-volume:/var/lib/influxdb \
  influxdb /init-influxdb.sh

docker-compose up -d