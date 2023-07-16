# Base image
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER Ubuntu
ENV ZDOTDIR /home/Ubuntu


#~~~~~~~~~~~~~~~UBUNTU-20.04 UPDATES AND DEPENDENCIES~~~~~~~~~~~~~~~~~~
RUN for i in {1..3}; do apt-get update && apt-get upgrade -y && break || sleep 5; done
RUN for i in {1..3}; do apt-get install -y dos2unix curl snapd dialog net-tools nano git sudo wget zsh build-essential apt-utils gpg libnss3-tools apt-transport-https gnupg2 lsb-release passwd && break || sleep 5; done
RUN for i in {1..3}; do apt-get install -y --fix-missing dos2unix curl snapd dialog net-tools nano curl git sudo wget zsh build-essential apt-utils gpg libnss3-tools apt-transport-https gnupg2 lsb-release passwd && break || sleep 5; done


#~~~~~~~~~~~~~~~SET PERMISSIONS FOR RUNTIME~~~~~~~~~~~~~~~~~
RUN useradd -m -s /bin/zsh -g root Ubuntu; \
    echo "Ubuntu:Hello!" | chpasswd; \
    echo "Ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
    chown -R Ubuntu:root /home/Ubuntu
USER Ubuntu


#~~~~~~~~~~~~~~~OH MY ZSH AND EXTENSIONS~~~~~~~~~~~~~~~
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# Install zsh-autosuggestions plugin
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /home/Ubuntu/.oh-my-zsh/plugins/zsh-autosuggestions
# Install spaceship-prompt theme
RUN git clone https://github.com/spaceship-prompt/spaceship-prompt.git "/home/Ubuntu/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1 && \
    ln -s "/home/Ubuntu/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "/home/Ubuntu/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
# Copy preconfigured .zshrc file over
COPY --chown=Ubuntu:root /resources/.zshrc /home/Ubuntu/.zshrc
USER root
#set default shell as zsh
RUN chsh -s $(which zsh) Ubuntu


#~~~~~~~~~~~~~~~~TOOLS INSTALLATION~~~~~~~~~~~~~~~~~~~
COPY /resources/setup_tools.sh /tmp/setup_tools.sh
RUN chmod +x /tmp/setup_tools.sh

#housekeeping for tools
RUN mkdir -p /home/Ubuntu/.bosun && chown -R Ubuntu:root /home/Ubuntu/.bosun; \
    mkdir -p /home/Ubuntu/.local && chown -R Ubuntu:root /home/Ubuntu/.local; \
    mkdir -p /home/Ubuntu/.local/share && chown -R Ubuntu:root /home/Ubuntu/.local/share; \
    mkdir -p /home/Ubuntu/.local/share/lpass && chown -R Ubuntu:root /home/Ubuntu/.local/share/lpass; \
    mkdir -p /home/Ubuntu/.config && chown -R Ubuntu:root /home/Ubuntu/.config; \
    mkdir -p /home/Ubuntu/.config/lpass && chown -R Ubuntu:root /home/Ubuntu/.config/lpass; \
    mkdir -p /home/Ubuntu/buildout-resources && chown -R Ubuntu:root /home/Ubuntu/buildout-resources; \
    mkdir -p /home/Ubuntu/wsl-scripts && chown -R Ubuntu:root /home/Ubuntu/wsl-scripts
    
USER Ubuntu
RUN /bin/zsh -c "source /tmp/setup_tools.sh"

#~~~~~~~~~~~~~~~~~~~~~~~~~COPY RESOURCES FOR USE~~~~~~~~~~~~~~~~~~~~~~~~~~~
COPY --chown=Ubuntu:root /resources/wsl.conf /etc/wsl.conf
COPY --chown=Ubuntu:root ./resources/bashrc /home/Ubuntu/.bashrc
COPY --chown=Ubuntu:root ./resources/hosts /home/Ubuntu/buildout-resources/hosts
COPY --chown=Ubuntu:root ./wsl-scripts /home/Ubuntu/wsl-scripts

#add user to wsl.conf
RUN echo "default=Ubuntu" >> /etc/wsl.conf
