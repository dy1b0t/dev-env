Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
Write-Host "Setting up Windows Environment for Build-Out."
Write-Host "You will be asked for Admin Privileges several times. Select 'Yes' to continue."
Write-Host "Verifying Powershell version and upgrading if necessary..."
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) }"
}
Write-Host "Verifying Powershell Readline (PSReadline) version and upgrading if necessary..."
if (!(Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -Confirm:$false
}
Write-Host "Verifying Powershell Git (Posh-Git) version and upgrading if necessary..."
if (!(Get-Module -ListAvailable -Name posh-git)) {
    Install-Module -Name posh-git -Scope CurrentUser -Force -Confirm:$false
}

Write-Host "Modifying Posh-Git settings..."
Import-Module posh-git

$GitPromptSettings.DefaultPromptWriteStatusFirst = $true
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n$([DateTime]::now.ToString('MM-dd-yyyy HH:mm:ss'))"
$GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = 0x808080
