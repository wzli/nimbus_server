#!/bin/bash
# setup variables
docker_image="wzli/ubuntu"

# run server
docker kill $(docker ps -q)
docker pull $docker_image
docker run --cpu-period=100000 --cpu-quota=80000 --memory="400m" \
--volume /mnt/ftp/docker:/home/wzli/ftp --hostname nimbus \
--user wzli --workdir /home/wzli -d -it $docker_image screen -S main
