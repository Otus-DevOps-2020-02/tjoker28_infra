#Ресурс для создания белого адреса
#resource "google_compute_global_address" "default" {
#  name = "global-app-ip"
#}
#Ресурс создания группы инстансов
resource "google_compute_instance_group" "puma-app" {
  name = "puma-app-group"
 instances = [google_compute_instance.app[0].self_link, google_compute_instance.app[1].self_link ]
 zone = var.zone
}

#Проверка состояния
resource "google_compute_http_health_check" "default" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

#Ресурс бэкенд
resource "google_compute_backend_service" "puma-app-backend" {
  name          = "puma-app-backend"
  health_checks = [google_compute_http_health_check.default.self_link]
}
# создаем балансировщик нагрузки
resource "google_compute_url_map" "urlmap" {
  name        = "urlmap"
  default_service = google_compute_backend_service.puma-app-backend.self_link
}

# https://cloud.google.com/load-balancing/docs/target-proxies
# создаем целевой прокси сервер
resource "google_compute_target_http_proxy" "default" {
  name    = "puma-proxy"
  url_map = google_compute_url_map.urlmap.self_link


}

# добавляем правила обработки трафика
resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-rule"
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
}
