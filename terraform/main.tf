terraform {
  # Версия terraform
  required_version = "~>0.12.19"
}
provider "google" {
  # Версия провайдера
  version = "~>2.15"
  # ID проекта
  project = var.project
  region  = var.region
}
#Добавление ключа SSH  в метаданные проекта
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}"
}
#Добавление 2 ключа SSH  в метаданные проекта
resource "google_compute_project_metadata_item" "ssh-keys2" {
  key   = "ssh-keys"
  value = "appuser2:${file(var.public_key_path)}"
}

#Ресурс для создания инстанса VM в GCP
resource "google_compute_instance" "app" {
  count        = var.count_instances
  name         = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "appuser"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

  metadata = {
    #путь до публичного ключа ssh
    ssh-keys = "appuser:${file(var.public_key_path)}"

  }
}
#Ресурс для создания правила FireWall
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
