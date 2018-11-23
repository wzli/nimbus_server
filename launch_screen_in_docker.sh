#!/bin/bash
docker exec -it $(docker ps -q) script --quiet --return --command "screen -x -R main -p +" /dev/null
