# tjoker28_infra
tjoker28 Infra repository
# ДЗ 3
```
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
```
# ДЗ 4
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

# ДЗ5
 Работа с Packer

Создан файл ubuntu16.json который создает образ в GCP согласно заданным параметрам в файле variables.json

Созданы и перенесены в директорию ./packer/scripts/ скрипты для установки MongoDB, Ruby и нашего сервиса
В файле ./packer/files/pumaapp.service параметры для system unit
```
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
```
Доп задание: создан immutable.json для создания готового образа с установленными зависимостями с помощью предыдущих скриптов. Он собирает образ reddit-full.
Так же создан скрипт create-redditvm.sh для создания новой VM на основе образа reddit-full


# ДЗ6
Работа с Terraform.
Сделаны конфигурационный файлы для создания VM, правила для FW, добавлены ключи для SSH  в метаданные VM и проекта.
При добавлении ключей в метаданные проекта через Веб при следующем использовании Терраформ ключ стирается
Задание со * по созданию балансировщика сделано через google_compute_forwarding_rule без использования прокси, мапа, бэкенда и т.д. Код получился более лаконичный и логичный.
Задание со * по использованию параметра Cgitount для количества создаваемых однотипных инстансов сделано.
Задание со * для вывода IP всех созданых инстансов и балансировщика сделано.

# ДЗ7
1) Создать новое хранилище с помощью подключаемого модуля storage-bucket: ```https://registry.terraform.io/modules/SweetOps/storage-bucket/google/0.3.1 ```
Или же руками через консоль:
``` gsutil mb gs://[BUCKET_NAME]/ ```
просмотр хранилищь ``` gsutil ls ```

2)создаем файл с указанием местом хранения стейта на google storage:
```
terraform {
  backend "gcs" {
    bucket = "my-homework7-bucket"
    prefix = "stage"
  }
}
```
После этого terraform init и terraform apply

# ДЗ8
Работа с Ansible
Сделан скрипт(script.py) на python, который берет список всех хостов GCP и выводит их в формате JSON.
Скрипт добавлен в качестве источника объектов(inventory) в конфигурационный файл ansible.cfg

# ДЗ9
Попробовано создание инфраструктуры с помощью плейбуков (один файл нужно задавать группы хостов к которым будет применяться этот файл через --limit и через теги --tags задания)
```
ansible-playbook reddit_app.yml --check --limit app --tags app-tag
#--check -флаг тестовой прогонки
```
Попробован варинат: в одном плейбуке лежит несколько сценариев (указывать нужно только теги, а нужные группы уже заложены в сценариях)
```
ansible-playbook reddit_app.yml --tags app-tag
```
Попробован вариант с несколькими плейбуками (один плейбук на задачу или группу хостов). Все плэйбуки запускаются из основного с помощью модуля import_playbook.

переписал скрипт для создания динамического инвентори (теперь на выходе json c разбивкой по группам)

Вместо shell скриптов в packer теперь используется ansible для устанловки пакетов
документация по модулям: https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html
документация по циклам: https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html

Важно использовать правильный формат описания цикла для установки пакетов:
```
- name: Install ruby & bundle
          apt: "name:{{ item }} state:present"
          with_items:
            - ruby-full
            - ruby-bundler
            - build-essential
```
На вариант с apt: pkg={{ item }}  ansible ругается

 Пути в JSON-файлах корректны, билд образов нужно производить из корня репозитория
 ```
 packer build -var-file=packer/variables.json  packer/app.json
 ```
 Для WSL может понадобиться задать еще пользователя "user": "appuser"

# ДЗ10

Созданы роли для app и db
Созданы в ansible два окружения stage и prod
В group_vars расположены переменные для определенного окружения
Добавлена в проект роль из ansible-galaxy jdauphant.nginx, ее переменные описаны в файле переменных app для каждого окружения
Обновлен общий playbook site.yml запуска всех ролей.
Для запуска из определенного окружения используется команда:
```
ansible-playbook -i environments/prod/d_inventory.py playbooks/users.yml
```

ansible vault. Зашифровали файл содержащий в явном виде логин-пароль.
Добавил в проект динамическое инвентори(скрипт из предыдущих ДЗ)
Поправлен playbook packer_app.yml В первоначальной версии не устанавливались все элементы, хотя никакой ошибки не выдавало.

# ДЗ11

Знакомство с Vagrant и Molecule:
В vagrant создание локального окружения
Провижиненинг в vagrant с помощью ansible. Инвентори генерится vagrant
```
cat .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
```
Разделены задачи в ролях по отдельным файлам. Добавлен параметр пользователя(вынесен в дефолты ролей)
Для локального тестирования Ansible ролей будем использован Molecule для создания машин и проверки конфигурации и Testinfra для написания тестов.
virtualenv и virtualenvwrapper
Задачи со * отложены, когда будет время.
