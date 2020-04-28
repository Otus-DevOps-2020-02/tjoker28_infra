variable region {
  #Регион
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
#Публичный ключ для подключения пользователя
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable zone {
  #Зона
  description = "Zone"
  # Значение по умолчанию
  default = "europe-west1-b"
}
#Количество создаваемых инстансов
variable count_instances {
  default     = "1"
  description = "Count of instances"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
