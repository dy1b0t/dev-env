#!/bin/zsh
source ~/.zshrc

prompt_tool_install() {
    tool_name=$1
    install_cmd=$2

    echo "~~~${tool_name} not found."
    echo "Please install it with the following command:"
    echo "${install_cmd}"
}

verify_tool() {
    tool_name=$1
    version_cmd=$2
    install_cmd=$3

    version_output=$(eval "${version_cmd}" 2>&1)

    if [[ $version_output == *"command not found"* ]]; then
        prompt_tool_install "${tool_name}" "${install_cmd}"
    else
        echo "~~~${tool_name} version: ${version_output}"
    fi
}

echo "~~~Verifying tools..."

# Go
verify_tool "Go" "go version" 'wget https://go.dev/dl/go1.18.10.linux-amd64.tar.gz \
    && sudo rm -rf /usr/local/go \
    && sudo tar -C /usr/local -xzf go1.18.10.linux-amd64.tar.gz \
    && sudo rm go1.18.10.linux-amd64.tar.gz'

# MKCert
verify_tool "MKCert" "mkcert --version" 'wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 \
    && sudo cp mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert \
    && sudo chmod +x /usr/local/bin/mkcert \
    && sudo mkcert -install \
    && sudo cp /root/.local/share/mkcert/rootCA.pem ~/buildout-resources/wsl.crt'

# Git
verify_tool "Git" "git --version" 'sudo DEBIAN_FRONTEND=noninteractive apt install git-all -y'

# VaultCLI
verify_tool "VaultCLI" "vault --version" 'sudo apt install -y vault'

# LastpassCLI
verify_tool "LastpassCLI" "lpass --version" 'sudo apt install -y lastpass-cli'

# Kubectl
verify_tool "Kubectl" "kubectl version --client=true --short=true" 'sudo apt install -y kubectl'

# Helm
verify_tool "Helm" "helm version" 'curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash'

# Bosun
verify_tool "Bosun" "bosun --version" 'wget https://github.com/naveego/bosun/releases/download/3.4.6/bosun_3.4.6_linux_amd64.tar.gz \
    && sudo tar -xzf bosun_3.4.6_linux_amd64.tar.gz \
    && sudo mv bosun /usr/local/bin/ \
    && sudo rm bosun_3.4.6_linux_amd64.tar.gz'

# NVM
verify_tool "NVM" "nvm --version" 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'

# Node.js
verify_tool "Node" "node --version" 'nvm install node'

# .NET SDK
for version in "2.2.207" "3.1.426" "5.0.408" "6.0.406"; do
    verify_tool ".NET SDK ${version}" "dotnet --list-sdks | grep ${version}" 'wget https://dot.net/v1/dotnet-install.sh \
        && chmod +x dotnet-install.sh \
        && ./dotnet-install.sh --version '${version}' \
        && rm dotnet-install.sh'
done

# Helm-diff
if ! helm plugin list | grep -q 'diff'; then
    prompt_tool_install "Helm-diff" "helm plugin install https://github.com/databus23/helm-diff"
else
    echo "~~~Helm-diff is installed"
fi
