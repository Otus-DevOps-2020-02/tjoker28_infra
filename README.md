# tjoker28_infra
tjoker28 Infra repository
ДЗ 3
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

bastion_IP = 35.187.118.52
someinternalhost_IP = 10.132.0.3

ДЗ 4

testapp_IP = 34.77.110.251
testapp_port = 9292

Команда для создания VM с использованием скрипта:
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=./startup_script.sh

Команда для создания правила FW
gcloud compute firewall-rules create default-puma-server --allow=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
