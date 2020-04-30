variable project {
  #Проект
  description = "Project ID"
}
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
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable db_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-db-base"
}
