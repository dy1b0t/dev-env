If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Write-Host "Verifying WSL2 and installing if necessary..."
if ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -ne 'Enabled') {
    Write-Host "Enabling the WSL optional feature in windows"
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    $CWD = Get-Location
    $Action = New-ScheduledTaskAction -Execute 'node' -Argument "$CWD\index.js setup"
    $Trigger = New-ScheduledTaskTrigger -AtStartup
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
    Register-ScheduledTask -TaskName "MyTask" -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal
    Write-Host "Your computer needs to be restarted to finish installing these features. Restart now?"
    Restart-Computer -Confirm
}

if ((Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -ne 'Enabled') {
    Write-Host "Enabling the Virtual Machine Platform required for WSL2"
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    $CWD = Get-Location
    $Action = New-ScheduledTaskAction -Execute 'node' -Argument "$CWD\index.js setup"
    $Trigger = New-ScheduledTaskTrigger -AtStartup
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
    $Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
    Register-ScheduledTask -TaskName "MyTask" -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal
    Write-Host "Your computer needs to be restarted to finish installing these features. Restart now?"
    Restart-Computer -Confirm
}
