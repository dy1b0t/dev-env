Write-Host "Verifying Docker and installing if necessary..."
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    $url = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
    $output = "$HOME\Downloads\DockerDesktopInstaller.exe"

    Invoke-WebRequest -Uri $url -OutFile $output

    Start-Process -FilePath "$HOME\Downloads\DockerDesktopInstaller.exe" -ArgumentList "install --accept-license --backend=wsl-2 --installation-dir=C:\Docker" -NoNewWindow -Wait
}

docker --version
