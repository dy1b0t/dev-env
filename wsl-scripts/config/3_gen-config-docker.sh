#!/bin/zsh

#`````````````````````````modifying docker/config.json```````````````````
#Create base64 encoded values
b64_token=$(echo -n ''${USERNAME}':'${GITHUB_TOKEN}'' | base64)

# Check if .docker directory exists, if not create it
[ ! -d "$HOME/.docker" ] && mkdir -p "$HOME/.docker"

# Create config.json
cat <<EOF > $HOME/.docker/config.json
{
    "auths": {
        "containers.pkg.github.com": {
            "auth": "${b64_token}"
        },
        "docker.pkg.github.com": {
            "auth": "${b64_token}"
        },
        "ghcr.io": {
            "auth": "${b64_token}"
        }
    },
    "credsStore": "desktop.exe"
}
EOF

file_path="$HOME/.docker/config.json"
echo "The following Docker config has been created at $file_path"
cat -e -v $file_path
