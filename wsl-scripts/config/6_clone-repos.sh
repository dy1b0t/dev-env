# #!/bin/zsh

# echo "Checking if repos directory exists"

# if [ -d "/home/Ubuntu/repos" ]
# then
#   echo "Directory /home/Ubuntu/repos already exists."
# else
#   echo "Directory /home/Ubuntu/repos does not exist. Creating now."
#   sudo mkdir /home/Ubuntu/repos
#   if [ $? -eq 0 ]; then
#     echo "Directory created successfully."
#   else
#     echo "Failed to create directory. Please check your permissions."
#     echo "If this persists. Please run 'sudo chown Ubuntu:root /home/Ubuntu'"
#     exit 1
#   fi
# fi

# sudo chown Ubuntu:root /home/Ubuntu/repos
# cd /home/Ubuntu/repos

# ~~~~~~~~~~~~~~~~Repos to Clone~~~~~~~~~~~~~~~~~~~~~~
# output=$(git clone git@github.com:namespace/repo 2>&1)
# echo $output

# if [[ $output == *"Cloning into"* ]]; then
#   echo "Repository cloning successful!"
# else
#   echo "Repository cloning failed, please check your setup."
#   echo "If this persists. Please rerun 'node index.js wslSetup -e 5'
#         otherwise, verify your ssh configuration to Github manually."
# fi
