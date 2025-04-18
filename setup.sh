#!/usr/bin/env bash
set -e

SISMARGARET_MINER_VERSION="1.5"

# Check the presence of multiple commands, list the missing commands and exit
# if some of them are missing.
check_commands_exist() {
    missing_commands=""
    for command in "$@"; do
        if ! command -v "$command" >/dev/null 2>&1; then
            missing_commands+="$command "
        fi
    done
    if [ -n "$missing_commands" ]; then
        echo "Missing commands: $missing_commands"
        echo "Please install them first."
        echo "sudo/wget/unzip are usually also available under package name sudo, wget and unzip."
        echo "Docker install instruction: https://docs.docker.com/engine/install/ubuntu/"
        exit 1
    fi
}

check_commands_exist sudo wget unzip docker

# Helper function to fetch a value from application.yml into same variable namd as the key
# Strips double quotes if they exist
get_value() {
    KEY="$1"
    VALUE=$(sed -n "/^${KEY}: /s/.*: //p" application.yml)

    # Remove leading/trailing double quote
    VALUE=$(echo "$VALUE" | sed 's/^"//;s/"$//')

    eval "$KEY="$VALUE""
}

# This may be an update, so let's cache specified authToken if application.yml exists
if [ -f application.yml ]; then
    get_value authToken
fi

# Download miner and its supplementary files
wget https://github.com/filthz/sismargaret/archive/refs/heads/main.zip -O main.zip

TMP_DIR=$(mktemp -d)
unzip main.zip -d "$TMP_DIR"
mv "$TMP_DIR"/sismargaret-main/* .
rm -rf "$TMP_DIR"
rm -f main.zip

wget https://github.com/filthz/sismargaret/releases/download/${SISMARGARET_MINER_VERSION}/sismargaret-miner -O sismargaret-miner

# Create needed folders
mkdir -pv logs data

# Helper function to set a value in application.yml
set_value() {
    KEY="$1"
    VALUE="$2"
    sed -i "/^${KEY}: /d" application.yml
    echo "${KEY}: \"${VALUE}\"" >> application.yml
}

# Unset default and update serverThreads in application.yml with nproc output
THREADS=$(nproc)
echo "Setting miner default serverThreads to $THREADS threads"
set_value serverThreads "$THREADS"

# Reuse current authToken if it's valid
if [[ "$authToken" == eyJ* ]]; then
    echo "Using existing authToken"
else
    while true; do
        read -p "Paste your authToken (starts with eyJ): " authToken
        # Strip the authToken of any leading/trailing whitespace
        authToken=$(echo "$authToken" | xargs)
        if [[ "$authToken" == eyJ* ]]; then
            break
        fi
        echo "Invalid authToken. Please try again."
    done
fi

# Update authToken in application.yml
set_value authToken "$authToken"

# Build the custom miner with Docker
./rebuild-miner.sh

# Provide some basic instructions then exit
echo "Miner installed/updated!"
echo "To start the miner please run:"
echo "bash start-miner.sh"

echo "To view miner log, check logs/miner.log in the miner folder"

echo "To stop the miner, run:"
echo "bash stop-miner.sh"

echo "To remove the miner, stop the miner, then simply delete the folder."
