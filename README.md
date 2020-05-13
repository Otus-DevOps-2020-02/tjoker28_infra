# tjoker28_infra
tjoker28 Infra repository
#ДЗ 3
``IdentityFile ~/.ssh/id_rsa
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
``
#ДЗ 4
``
testapp_IP = 34.77.110.251
testapp_port = 9292
``
Команда для создания VM с использованием скрипта:
``
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=./startup_script.sh
``
Команда для создания правила FW
``gcloud compute firewall-rules create default-puma-server --allow=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server``

#ДЗ5
 Работа с Packer

Создан файл ubuntu16.json который создает образ в GCP согласно заданным параметрам в файле variables.json

Созданы и перенесены в директорию ./packer/scripts/ скрипты для установки MongoDB, Ruby и нашего сервиса
В файле ./packer/files/pumaapp.service параметры для system unit
``
[Unit]
Description=PumaApp
After=network.target
After=mongod.service
[Service]
Type=simple
WorkingDirectory=/home/tjoker/reddit/
ExecStart=/usr/local/bin/pumactl start
[Install]
WantedBy=multi-user.target
``
Доп задание: создан immutable.json для создания готового образа с установленными зависимостями с помощью предыдущих скриптов. Он собирает образ reddit-full.
Так же создан скрипт create-redditvm.sh для создания новой VM на основе образа reddit-full


#ДЗ6
Работа с Terraform.
Сделаны конфигурационный файлы для создания VM, правила для FW, добавлены ключи для SSH  в метаданные VM и проекта.
При добавлении ключей в метаданные проекта через Веб при следующем использовании Терраформ ключ стирается
Задание со * по созданию балансировщика сделано через google_compute_forwarding_rule без использования прокси, мапа, бэкенда и т.д. Код получился более лаконичный и логичный.
Задание со * по использованию параметра Count для количества создаваемых однотипных инстансов сделано.
Задание со * для вывода IP всех созданых инстансов и балансировщика сделано.

#ДЗ7
Работа с Ansible
Сделан скрипт(script.py) на python, который берет список всех хостов GCP и выводит их в формате JSON.
Скрипт добавлен в качестве источника объектов(inventory) в конфигурационный файл ansible.cfg
