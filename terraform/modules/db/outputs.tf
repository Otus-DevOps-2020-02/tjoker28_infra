
output "db_external_ip_addresses" {
  value = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}"
}
#output "loadbalancer_external_ip_addres" {
# value = "${google_compute_global_forwarding_rule.default.ip_address}"
#value = "${google_compute_forwarding_rule.default.ip_address}"
#}
