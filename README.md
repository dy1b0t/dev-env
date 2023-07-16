#  Dev-Env Buildout Automation Tool

The  Dev-Env Buildout Automation tool is a command-line interface (CLI) designed to simplify and automate the setup and deployment of your development environment. 

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Options](#options)
- [Debugging](#debugging)
- [License](#license)

## Installation

To install the Dev-Env Buildout Automation tool, follow these steps:

1. Clone the repository
2. Navigate into the directory:
    ```
    cd dev-env
    ```
3. Install the necessary dependencies:
    ```
    npm install
    ```

## Usage
The default username is Ubuntu, the default password is Hello!. You should change your pass with the following command:
```
sudo passwd Ubuntu
```
The easiest way to connect to your distro is in VSCode at the bottom left of the screen with the "Open a Remote Window" button.
However, it is recommended that you become familiar with wsl usage and the following commands:

    wsl (enter WSL as the default user)
    wsl --user[-u] <username> (enters WSL as a given user)
    wsl --shutdown (for hard resets)
    wsl --list (list the available wsl distros)
    wsl --export <distro name> (This will save an image of your distro if you need to create a backup)
    wsl --unregister <distro name> (This will wipe any work on your distro, you should export it before doing this.)

Please, don't interrupt the builder in step two, as it has been known to break docker. Wait for an exit. If it fails, run again with -v. 

### What's Included

This WSL system is configured to boot with Systemd, which means you can run you snap services, which was necessary for me in using Microk8s with this.

The following tools are included and can be modified in the setup_tools.sh script (installed as Ubuntu $USER):
- GO,
- MKCert,
- Git,
- ValutCLI,
- LastpassCLI,
- Kubectl,
- Helm,
- Helm-diff,
- .NET SDKs versions 2.2.207, 3.1.426, 5.0.408, 6.0.406
- NVM,
- Node 16.19.0

Additionally, some general configurations are executed within WSL, which can be found in wsl-scripts directory.

### Requirements

This setup and installation assumes a clean Windows environment without Docker or VSCode currently installed.
This CLI installer runs on Node. If your windows environment does not yet have node. Find it here: https://nodejs.org/en/download.

### Setting Up the Environment

To set up your environment, use the `devenvSetup` command:

    node index.js devenvSetup

### Building the Custom Distro for WSL

To build the  distro, use the `devenvDeploy` command:

    node index.js devenvDeploy

### WSL Housekeeping

To build the  distro, use the `devenvDeploy` command:

    node index.js wslDeploy

### Basic Config Operations

To build the  distro, use the `devenvDeploy` command:

    node index.js mk8sSetup
    
## Options

The Dev-Env Buildout Automation tool comes with several options to customize its behavior:

- `-e`, `--entryPoint`: Specifies the file number at which the script will begin.
- `-s`, `--singlePoint`: Runs only a single script.
- `-v`, `--verbose`: Enables verbose logging. (Recommended)

For more information on these options, use the `--help` command:

    node index.js --help (run this first)

## Debugging

- Problem running Windows Scripts to build? Verify your Execution Policy: ```Get-Execution Policy``` and set it to: ```Set-ExecutionPolicy Bypass -Scope CurrentUser -Force```. You may also need to install PowerShell by hand, as this is not the same as WindowsPowershell, but is necessary for current functionality.
- Build missed something? WSL --unregister, delete both the ubuntu-20.04-custom folder and ubuntu-20.04-custom.tar.gz and try again.
- Docker Desktop is installed by default to a directory with white space in it...This has been known to cause problems. It is recommended to uninstall Docker Desktop before beginning, and let the program install it for you. The installer.exe may remain in your Downloads folder if you already have it.
- Connection issues between windows and wsl? Check /etc/hosts and C:\\Windows\\System32\\hosts.
- Microk8s TLS issues? Check ```mkcert --install``` and make sure your .crt got imported into Windows Trusted Root Certification Authorities.
- Permission issues? ```sudo chown <username>:root /path/to/directory```
- Snap issues? Make sure WSL is booting as systemd with ```ps -p 1```(this should show systemd), if not, modify your /etc/wsl.conf with the one in this repo, and add ```default=Ubuntu``` under User.
- Path issues, or a program not being recognized? Make sure wsl.conf has ```appendWindowsPath=true``` under Interop, and that your .zshrc is not overriding it somewhere.

When in doubt, it is always a safe bet to exit WSL with ```exit```, or by closing VSCode, and resetting with ```wsl --shutdown```. This will not erase any work.

## License

This project is licensed under the terms of the [ISC license](LICENSE).


