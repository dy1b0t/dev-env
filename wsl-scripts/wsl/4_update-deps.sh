#!/bin/zsh
source ~/.zshrc

#Just in case, updating and installing lpass deps.
retry=0
MAX_RETRIES=3
while [ $retry -lt $MAX_RETRIES ]; do
    sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y install \
        bash-completion \
        libcurl4 \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2 \
        libxml2-dev \
        libssl1.1 \
        pkg-config \
        ca-certificates \
        xclip || {
        echo "Error occurred during package installation. Retrying..."

        sudo DEBIAN_FRONTEND=noninteractive apt-get -y --fix-missing install \
            bash-completion \
            libcurl4 \
            libcurl4-openssl-dev \
            libssl-dev \
            libxml2 \
            libxml2-dev \
            libssl1.1 \
            pkg-config \
            ca-certificates \
            xclip
        retry=$((retry + 1))
        sleep 1
        continue
    }
    break
done

# Set timezone non-interactively
export DEBIAN_FRONTEND=noninteractive
export TZ=America/New_York
sudo dpkg-reconfigure --frontend noninteractive tzdata
# Verify timezone
date +%Z
