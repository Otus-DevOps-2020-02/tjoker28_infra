#output "app_external_ip"{
#value="${google_compute_instance.app[count.index].network_interface.0.access_config.0.nat_ip}"
#}
output "compute_instance_external_ip_addresses" {
	value = "${google_compute_instance.app[*].network_interface.0.access_config.0.nat_ip}"
}
output "loadbalancer_external_ip_addres" {
	value = "${google_compute_global_forwarding_rule.default.ip_address}"
}
