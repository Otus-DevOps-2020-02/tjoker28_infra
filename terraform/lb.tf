#Проверка состояния
resource "google_compute_http_health_check" "default" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 10
  timeout_sec        = 5
  port = "9292"

}

#Ресурс пул VM
resource "google_compute_target_pool" "puma-app-pool" {
  name          = "puma-app"
  instances = google_compute_instance.app[*].self_link
  health_checks = [google_compute_http_health_check.default.self_link]
}

# добавляем правило перенаправления трафика
resource "google_compute_forwarding_rule" "default" {
  name       = "lb"
  target     = google_compute_target_pool.puma-app-pool.self_link
  port_range = "9292"
}
