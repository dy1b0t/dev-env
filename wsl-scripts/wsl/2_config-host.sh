#!/bin/zsh
source ~/.zshrc
#microk8s info will display an error with capital letters in hostnames...
#This being the case, since our app is picky, we will change it now.
# current_hostname=$(hostname)

# # Convert the hostname to lowercase
# lowercase_hostname=$(echo "$current_hostname" | tr '[:upper:]' '[:lower:]')

# # Set the new lowercase hostname
# sudo hostnamectl set-hostname $lowercase_hostname

# Check if the file contains 'aunalytics'
if ! grep -q 'aunalytics' /etc/hosts; then
    echo "Updating the hosts file..."

    # Modify hosts file to include hostname via sed substitution
    sudo sed -i "s/\$(hostname)/$(hostname)/g" /home/Ubuntu/buildout-resources/hosts

    sudo mv /home/Ubuntu/buildout-resources/hosts /etc/hosts
else
    echo "'Host is up to date. Nothing has changed."
fi
