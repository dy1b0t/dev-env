#!/bin/zsh


# ````````````````generating rsa and linking site to add key to...waiting for user response to continue```````````````````
echo "Generating RSA key to paste into GitHub for SSH functionality."
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
echo "RSA key generated."

# Start the ssh-agent in the background
eval "$(ssh-agent -s)"

# Add your SSH private key to the ssh-agent
ssh-add ~/.ssh/id_rsa

# copy public key to clipboard
xclip -sel clip < ~/.ssh/id_rsa.pub
echo "Public key copied to clipboard."

# open GitHub in browser
cmd.exe /c "start https://github.com/settings/keys"
echo "GitHub settings opened in browser. Please paste your key and click 'New SSH key'."

# wait for user confirmation
echo -n "Once you have input the rsa key into your New SSH Key in Github, press any key to continue."
read input

# Test SSH connection
echo "Testing SSH connection to GitHub"
output=$(/usr/bin/ssh -T git@github.com 2>&1)

if [[ $output == *"successfully authenticated"* ]]; then
  echo "SSH connection to GitHub successful!"
else
  echo "SSH connection to GitHub failed, please check your setup."
  echo "If this persists, please launch wsl (wsl -u Ubuntu) and follow these steps:"
  echo "
        generate key:
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N \"\"
        start service:
        eval \"\$(ssh-agent -s)\"
        add key:
        ssh-add ~/.ssh/id_rsa
        copy key:
        xclip -sel clip < ~/.ssh/id_rsa.pub
        create new key and paste:
        https://github.com/settings/keys and add your new key.\"
        test:
        ssh -T git@github.com
        "
fi
