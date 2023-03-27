#!bin/bash

dockerfile=$(pwd)/docker_20.10.5_armhf.ipk

#install docker file
echo "installing docker"
opkg install --force-reinstall $dockerfile

echo "loading api image"
docker load < $(pwd)/api.tar


echo "running api container"
docker run -d --init \
--restart unless-stopped --privileged \
--network=host \
-v kbusapidata:/etc/kbus-api \
-v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
jessejamescox/pfc-kbus-api

# build the resources for the broker
echo "creating /mosquitto directory"
mkdir /mosquitto 

# copy the config
cp $(pwd)/mosquitto.conf /mosquitto

# load the docker image
echo "loading mosquitto image"
docker load < mqttbroker.tar

#rename the docker image
docker tag c4 mqttbroker:latest

echo "running mosquitto broker container"
docker run -d -p 1883:1883 -v\
 /mosquitto/mosquitto.conf:/mosquitto/config/mosquitto.conf \
--restart unless-stopped mqttbroker:latest

echo "loading nodered"
docker load < nodered.tar
#docker tag 0b0 nodered:latest

echo "untar the volume"
tar -xvf $(pwd)/noderedvolume.tar  -C /

echo "running node-red container"
docker run --restart unless-stopped -d -p 1880:1880 --name node-red \
--network=host --security-opt seccomp:unconfined \
-v node_red_user_data:/data nodered/node-red:latest-minimal 


