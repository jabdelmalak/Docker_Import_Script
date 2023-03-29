#!bin/bash

echo "loading node red"
docker load < $(pwd)/noderedimage.tar

echo "untar the node red volume"
tar -xvf $(pwd)/noderedvolume.tar  -C /

echo "starting node red container"
docker run --restart unless-stopped -d -p 1880:1880 -v node_red_data:/data nodered/node-red

echo "loading grafana"
docker load < $(pwd)/grafanaimage.tar

echo "untar the grafana volume"
tar -xvf $(pwd)/grafanavolume.tar  -C /

echo "starting grafana"
docker run --restart unless-stopped -d -p 3000:3000 -v 64aafa824594fabeec029d8cefe61729369e0bcbcecffc459881dcda7842ca90:/data grafana/grafana

echo "loading influxdb"
docker load < $(pwd)/influxdbimage.tar

echo "starting influxdb"
docker run --restart unless-stopped -d -p 8086:8086 -v influx_data:/data influxdb:1.8

echo "setting volume permissions"
chmod 777 /var/lib/docker/volumes/node_red_data/_data
chmod 777 /var/lib/docker/volumes/64aafa824594fabeec029d8cefe61729369e0bcbcecffc459881dcda7842ca90
chmod 777 /var/lib/docker/volumes/influx_data



