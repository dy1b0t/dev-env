#!/bin/zsh
# Install all of the following tools:
# GO,
# MKCert,
# Git,
# ValutCLI,
# LastpassCLI,
# Kubectl,
# Helm,
# Helm-diff,
# Bosun,
# .NET SDKs,
# NVM,
# Node 16.19.0

cd /home/Ubuntu
source ~/.zshrc

# Ensure proper update
MAX_RETRIES=3
retry=0

while [ $retry -lt $MAX_RETRIES ]; do
  sudo DEBIAN_FRONTEND=noninteractive apt update
  sudo DEBIAN_FRONTEND=noninteractive apt install -y || {
    echo "Error occurred during package installation. Retrying..."
    sudo DEBIAN_FRONTEND=noninteractive apt install -y --fix-missing
    retry=$((retry + 1))
    sleep 1
    continue
  }
  break
done

# /// GO  ///
# Install and clean
if ! go version >/dev/null 2>&1; then
  wget https://go.dev/dl/go1.18.10.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go1.18.10.linux-amd64.tar.gz
  sudo rm go1.18.10.linux-amd64.tar.gz
fi

# /// MKCert  ///
if ! mkcert --version >/dev/null 2>&1; then
  wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
  sudo cp mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert
  sudo chmod +x /usr/local/bin/mkcert
fi

# /// Git ///
if ! git --version >/dev/null 2>&1; then
  sudo DEBIAN_FRONTEND=noninteractive apt install git-all -y
fi

# /// VaultCLI ///
if ! vault --version >/dev/null 2>&1; then
  desired_fingerprint="798AEC654E5C15428C8E42EEAA16FCBCA621E701" # Desired fingerprint
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  actual_fingerprint=$(gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint | tr -d ' ' | grep -Eo '[A-Z0-9]{40}')
  if [[ "$actual_fingerprint" != "$desired_fingerprint" ]]; then
    echo "Fingerprints do not match for vault install"
    echo "Desired fingerprint: $desired_fingerprint"
    echo "Actual fingerprint: $actual_fingerprint"
  else
    echo "Fingerprints match!"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install vault -y
  fi
fi

# /// LastpassCLI ///
# deps
while [ $retry -lt $MAX_RETRIES ]; do
  sudo DEBIAN_FRONTEND=noninteractive apt-get -y install \
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

echo "lpass start"
if ! lpass --version >/dev/null 2>&1; then
  sudo apt install -y lastpass-cli
fi

# /// Kubectl ///
echo "kubectl start"
if ! kubectl version --client=true --short=true >/dev/null 2>&1; then
  sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
  sudo chown -fR $USER ~/.kube
fi

# /// Helm ///
if ! helm version >/dev/null 2>&1; then
  sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash
fi

# /// Helm-diff /// This diff --version is def not diff
if ! helm plugin list | grep -q "diff"; then
  helm plugin install https://github.com/databus23/helm-diff
fi

# /// Bosun ///
# clone
if ! bosun --version >/dev/null 2>&1; then
  wget https://github.com/naveego/bosun/releases/download/3.4.6/bosun_3.4.6_linux_amd64.tar.gz
  # extract and install
  sudo tar -xzf bosun_3.4.6_linux_amd64.tar.gz
  sudo mv bosun /usr/local/bin/
  # clean up
  sudo rm bosun_3.4.6_linux_amd64.tar.gz
fi

# /// DOTNET SDKS ///
wget https://dot.net/v1/dotnet-install.sh
sudo chmod +x dotnet-install.sh
./dotnet-install.sh --version 2.2.207
./dotnet-install.sh --version 3.1.426
./dotnet-install.sh --version 5.0.408
./dotnet-install.sh --version 6.0.406

rm dotnet-install.sh

# /// NVM (Node version manager, which includes npm) ///
if ! command -v nvm >/dev/null 2>&1; then
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# /// Node ///
if ! node --version | grep -q "v16.19.0"; then
  nvm install v16.19.0
  nvm alias default 16.19.0
fi

# /// Cleanup at the end ///
sudo apt-get autoremove -y && sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

source ~/.zshrc

# VERIFICATION FOR TESTING
echo "~~~Go version: $(go version)"
echo "~~~MKCert version: $(mkcert --version)"
echo "~~~Git version: $(git --version)"
echo "~~~VaultCLI version: $(vault --version)"
echo "~~~LastpassCLI version: $(lpass --version)"
echo "~~~Helm version: $(helm version)"
echo "~~~Helm-diff version: $(helm plugin list)"
echo "~~~Kubectl version: $(kubectl version --client=true --short=true)"
echo "~~~Bosun version: $(bosun --version)"
echo "~~~.NET SDK versions:"
dotnet --list-sdks
echo "~~~NVM version: $(nvm --version)"
echo "~~~Node version: $(node --version)"
