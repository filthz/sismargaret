#!/usr/bin/env bash
sudo docker stop $(sudo docker ps -aq -f name=sismargaret-miner)
sudo docker rm $(sudo docker ps -aq -f name=sismargaret-miner)

# Autodetect miner directory
MINER_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
sudo docker run --init -it -v ${MINER_DIR}/logs:/logs -v ${MINER_DIR}/data:/tmp/dreadpool -p 7777:7777 -p 24242:24242 --name sismargaret-miner -d --restart unless-stopped sismargaret-miner

echo "To view miner log, check logs/miner.log in the miner folder"

echo "To stop the miner, run:"
echo 'sudo docker stop $(sudo docker ps -aq -f name=sismargaret-miner); sudo docker rm $(sudo docker ps -aq -f name=sismargaret-miner)'

echo "To remove the miner, stop the miner, then simply delete the folder."
