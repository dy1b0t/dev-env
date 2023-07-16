Write-Host "Verifying VSCode and installing if necessary..."
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    $url = "https://aka.ms/win32-x64-user-stable"
    $output = "$HOME\Downloads\VSCodeUserSetup-x64.exe"

    Invoke-WebRequest -Uri $url -OutFile $output

    Start-Process -FilePath "$HOME\Downloads\VSCodeUserSetup-x64.exe" -ArgumentList "/silent /install:C:\VSCode" -NoNewWindow -Wait
}

Write-Host "Verifying VS Code installation..."
code --version
