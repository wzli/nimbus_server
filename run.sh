#!/bin/bash
# setup variables
docker_image="wzli/ubuntu"
tls_dir="/etc/letsencrypt/live/us.wenzheng.li"
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# run server
while true; do
    pkill gotty
    docker kill $(docker ps -q)
    # renew ssl certificates
    certbot renew
    # start a docker container
    docker pull $docker_image
    docker run --cpu-period=100000 --cpu-quota=80000 --memory="400m" \
        --volume /mnt/ftp/docker:/home/wzli/ftp --hostname nimbus \
        --user wzli --workdir /home/wzli -d -it $docker_image screen -S main
    # launch the terminal server
    $script_dir/gotty --permit-write --reconnect --reconnect-time 3 --close-timeout 5 --port 443 \
        --tls --tls-crt $tls_dir/fullchain.pem --tls-key $tls_dir/privkey.pem \
        --title-format "Wen's Cloud Console" $script_dir/launch_screen_in_docker.sh &
    # kill 3 times a day
    sleep 30000
done
