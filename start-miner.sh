#!/usr/bin/env bash
sudo docker stop $(sudo docker ps -aq -f name=sismargaret-miner)
sudo docker rm $(sudo docker ps -aq -f name=sismargaret-miner)
sudo docker run --init -it -v $(pwd)/logs:/logs -v $(pwd)/data:/tmp/dreadpool -p 7777:7777 -p 24242:24242 --name sismargaret-miner -d --restart unless-stopped sismargaret-miner

echo "To view miner log, check the logs folder or run this command:"
echo 'sudo docker logs -f $(sudo docker ps -aq -f name=sismargaret-miner)'

echo "To stop the miner, run:"
echo 'sudo docker stop $(sudo docker ps -aq -f name=sismargaret-miner); sudo docker rm $(sudo docker ps -aq -f name=sismargaret-miner)'

echo "To remove the miner, stop the miner, then simply delete the folder."
