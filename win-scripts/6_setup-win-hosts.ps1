# If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
#     $arguments = "& '" + $myinvocation.mycommand.definition + "'"
#     Start-Process powershell -Verb runAs -ArgumentList $arguments
#     Break
# }

# # Modify hosts file
# @"
# 127.0.0.1 myservice.example.local
# 127.0.0.1 identity.example.local
# 127.0.0.1 database.example.local
# 127.0.0.1 messagequeue.example.local
# 127.0.0.1 search.example.local
# 127.0.0.1 email.example.local
# 127.0.0.1 vault.example.local
# 127.0.0.1 api.example.local
# 127.0.0.1 dataflow.example.local
# 127.0.0.1 metabase.example.local
# 127.0.0.1 minikube-host.example.local
# "@ | Out-File -FilePath C:\Windows\System32\drivers\etc\hosts -Append
