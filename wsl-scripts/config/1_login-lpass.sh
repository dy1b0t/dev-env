#!/bin/zsh

echo -n "Enter lastpass email: "
read email
sudo chown $USER /home/${USER}/.local/share/lpass

lpass login ${email}
lpass sync

username="${email%@*}"
export USERNAME="$username"