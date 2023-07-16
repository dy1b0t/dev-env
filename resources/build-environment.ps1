Write-Output "Checking for Docker install"

function Docker() {
    Write-Output "Building Docker container"
    try {
        docker build --build-arg USER=Ubuntu --build-arg PASS=Hello! -t ubuntu-20.04-custom -f resources\Dockerfile . -ErrorAction Stop
    }
    catch {
        docker run --name ubuntu-20.04-custom ubuntu-20.04-custom
    }
    docker start ubuntu-20.04-custom
    docker export --output="ubuntu-20.04-custom.tar.gz" ubuntu-20.04-custom
    docker container rm ubuntu-20.04-custom
    docker rmi ubuntu-20.04-custom
    Write-Output "1-Current location: $(Get-Location), PWD: ${PWD}"
    Import
}

function Builder() {
    Write-Output "Building Docker container using builder distro"
    wsl --set-default-version 2
    wsl --import builder .\builderInstall .\resources\builder\alpine-builder.tar.gz --version 2
    wsl -d builder -u root sh -c "pwd; ls -la resources/builder/"
    wsl -d builder -u root sh -c "resources/builder/build-tar.sh Ubuntu"
    wsl --unregister builder
    Remove-Item -Path .\builderInstall -Recurse
    Import
}
function Builder() {
    Write-Output "Building Docker container using builder distro"
    wsl --set-default-version 2
    wsl --import builder .\builderInstall .\resources\builder\alpine-builder.tar.gz --version 2
    wsl -d builder -u root sh -c "pwd; ls -la resources/builder/"
    wsl -d builder -u root sh -c "resources/builder/build-tar.sh Ubuntu"
    wsl --unregister builder
    Remove-Item -Path .\builderInstall -Recurse
    Import
}

function Import() {
    Write-Output "Importing the new distro"
    wsl --set-default-version 2
    wsl --update
    Write-Output "2-Current location: $(Get-Location), PWD: ${PWD}"
    wsl --import ubuntu-20.04-custom ${PWD}\ubuntu-20.04-custom .\ubuntu-20.04-custom.tar.gz
    wsl --set-default ubuntu-20.04-custom
}

if (Test-Path .\ubuntu-20.04-custom.tar.gz) {
    Import
} 
else {
    if (-not(Get-Command helm -ErrorAction SilentlyContinue)) {
        Builder
    } 
    else {
        Docker
    }
}
