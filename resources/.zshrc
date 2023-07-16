# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
export PATH="$PATH:/mnt/c/Windows/System32"
#the two following exports are suggestions from a microk8s setup error.
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

ZSH_THEME="spaceship"
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  # host          # Hostname section
  git           # Git section (git_branch + git_status)
  #hg            # Mercurial section (hg_branch  + hg_status)
  #package       # Package version
  node          # Node.js section
  #ruby          # Ruby section
  #elixir        # Elixir section
  #xcode         # Xcode section
  #swift         # Swift section
  golang        # Go section
  #php           # PHP section
  #rust          # Rust section
  #haskell       # Haskell Stack section
  #julia         # Julia section
  #docker        # Docker section
  # aws           # Amazon Web Services section
  #venv          # virtualenv section
  #conda         # conda virtualenv section
  #pyenv         # Pyenv section
  dotnet        # .NET section
  #ember         # Ember.js section
  kubectl       # Kubectl context section  
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  #vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_RPROMPT_ORDER=(
  time
)
SPACESHIP_TIME_SHOW=true
SPACESHIP_BATTERY_THRESHOLD=25
SPACESHIP_BATTERY_SHOW=true
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_SYMBOL=""
# SPACESHIP_PACKAGE_SHOW=false
# SPACESHIP_GOLANG_SHOW=false
# SPACESHIP_DOTNET_SHOW=true
# SPACESHIP_KUBECTL_VERSION_SHOW=false
# SPACESHIP_BATTERY_SHOW=false
# SPACESHIP_AWS_SHOW=false
#ZSH_THEME="powerlevel9k/powerlevel9k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git kubectl npm helm vault docker zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh
# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
# Compilation flags
# export ARCHFLAGS="-arch x86_64"
# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
#PATH
export PATH=$PATH:$HOME/bin
export PATH=$PATH:/opt/vault
export PATH=$PATH:/opt/nodejs/bin
export PATH=$PATH:/opt/helm/linux-amd64
export PATH=$PATH:/opt/mssql-tools/bin

#ALIAS
unalias kaf
# Kube
alias k="kubectl"
alias kpa="kubectl get pods --all-namespaces --sort-by=metadata.namespace"
alias k_clean="kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod"
alias kks='k -n kube-system'
alias k_d="kubectl config set-context --current --namespace=default"
alias k_t="kubectl config set-context --current --namespace=tenants"
alias k_log="kubectl config set-context --current --namespace=logging"
alias k_leg="kubectl config set-context --current --namespace=legacy"

#COMMON TOOLS
alias k='kubectl'
alias flushdns='sudo /etc/init.d/networking restart'
#SHELL CONFIG FILE
alias s_zshrc='source ~/.zshrc'
alias e_zshrc='code ~/.zshrc'
#APACHE
alias a_stop='sudo /etc/init.d/apache2 stop'
#ENV
export EDITOR="code --wait" 
export HELM_HOME=$HOME/helm
export GITHUB_TOKEN=$(lpass show github-token --password)
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
#GO CONFIG
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
# GO
export GO111MODULE=on
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:/usr/local/go/bin
#DOTNET
export PATH=$PATH:$HOME/.dotnet
#REPOS
export PATH=$PATH:$HOME/repos
#MICROK8S
export PATH=/snap/bin:$PATH
#Kube config
export KUBECONFIG="$HOME/.kube/config"
#NVM
export NVM_DIR="$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias mk='microk8s'

export PATH=$HOME/.bin:$PATH
