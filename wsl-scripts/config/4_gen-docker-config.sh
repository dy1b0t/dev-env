# #!/bin/zsh

# echo "Please ensure Docker Desktop is running. Is Docker running? [y/n]"
# read docker_running

# if [ "$docker_running" != "y" ]; then
#     echo "Please start Docker Desktop and try again."
#     exit 1
# fi

# docker login -u $USERNAME -p $GITHUB_TOKEN docker.pkg.github.com

# if [ $? -eq 0 ]; then
#   echo "Successfully logged in to Docker. Refreshing /.docker/config.json"
#   # this needs to call the previous script if it works, to generate the config
#   # one more time, since docker login will remove the used token from config.
#   /home/Ubuntu/wsl-scripts/mk8s/setup/3_gen-config-docker.sh
# else
#   echo "Docker login failed."
#   exit 1
# fi