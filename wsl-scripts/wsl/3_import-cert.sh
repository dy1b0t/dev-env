#!/bin/zsh
source ~/.zshrc

mkcert -install
sudo cp /home/Ubuntu/.local/share/mkcert/rootCA.pem ~/buildout-resources/wsl.crt

CERT_PATH="/home/Ubuntu/buildout-resources/wsl.crt"

if [[ -f "$CERT_PATH" ]]; then
    WIN_CERT_PATH=$(wslpath -w "$CERT_PATH")

    powershell.exe -Command "Start-Process cmd -ArgumentList '/c certutil -addstore -f Root $WIN_CERT_PATH' -Verb RunAs -Wait"

    echo "Certificate has been imported."
else
    echo "Certificate not found at $CERT_PATH"
fi
