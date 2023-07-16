#!/bin/zsh

echo "Please ensure Docker Desktop is running. Is Docker running? [y/n]"
read docker_running

if [ "$docker_running" != "y" ]; then
    echo "Please start Docker Desktop and try again."
    exit 1
fi

if id -nG "$USER" | grep -qw "docker"; then
    echo "User $USER is already in the docker group. No action taken."
else
    # Add
    echo "Adding $USER to docker group."
    sudo usermod -aG docker $USER
    # Verify
    if id -nG "$USER" | grep -qw "docker"; then
        echo "$USER has been added to docker group."
    else
        echo "Failed to add $USER to docker group."
    fi
fi
