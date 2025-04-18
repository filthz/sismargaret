#!/usr/bin/env bash
# Autodetect miner directory
MINER_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

# First stop the miner
${MINER_DIR}/stop-miner.sh

# Start the miner
sudo docker run --init -it -v ${MINER_DIR}/logs:/logs -v ${MINER_DIR}/data:/tmp/dreadpool -p 7777:7777 -p 24242:24242 --name sismargaret-miner -d --restart unless-stopped sismargaret-miner

echo "To view miner log, check logs/miner.log in the miner folder"

echo "To stop the miner, run:"
echo "bash stop-miner.sh"

echo "To remove the miner, stop the miner, then simply delete the folder."
