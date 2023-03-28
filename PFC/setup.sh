#!bin/bash

#dockerfile=$(pwd)/docker_20.10.5_armhf.ipk

#install docker file
#echo "installing docker"
#opkg install --force-reinstall $dockerfile

echo "loading nodered"
docker load < nodered.tar
#docker tag 0b0 nodered:latest

echo "untar the volume"
tar -xvf $(pwd)/noderedvolume.tar  -C /

echo "running node-red container"
docker run --restart unless-stopped -d -p 1880:1880 --name node-red \
--network=host --security-opt seccomp:unconfined \
-v node_red_user_data:/data nodered/node-red:2.2.2

chmod 777 /home/docker/volumes/node_red_user_data/_data

