# tjoker28_infra
tjoker28 Infra repository

IdentityFile ~/.ssh/id_rsa
ServerAliveInterval 240
PreferredAuthentications publickey

Host bastion
HostName 35.187.118.52
User tjoker

Host someinternalhost
Hostname 10.132.0.3
User tjoker
ProxyCommand ssh -W %h:%p bastion
