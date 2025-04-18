#!/usr/bin/env bash
sudo docker stop $(sudo docker ps -aq -f name=sismargaret-miner)
sudo docker rm $(sudo docker ps -aq -f name=sismargaret-miner)
