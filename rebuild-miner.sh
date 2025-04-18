#!/usr/bin/env bash
MINER_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

sudo docker build -t sismargaret-miner -f $MINER_DIR/Dockerfile $MINER_DIR
