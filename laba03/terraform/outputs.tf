output "load_balancer_public_ip" {
  description = "Public IP address of load balancer"
  value = tolist(tolist(yandex_lb_network_load_balancer.wp_lb.listener).0.external_address_spec).0.address
}

output "database_host_fqdn" {
  description = "DB hostname"
  value = tolist(local.dbhosts)[0]
}

output "vm_linux_public_ip_address_1" {
  description = "Virtual machine IP 1"
  value = yandex_compute_instance.wp-app[0].network_interface[0].nat_ip_address
}

output "vm_linux_public_ip_address_2" {
  description = "Virtual machine IP 1"
  value = yandex_compute_instance.wp-app[1].network_interface[0].nat_ip_address
}
