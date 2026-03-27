output "vm_linux_public_ip_address_1" {
  description = "Virtual machine IP srv-db21"
  value = yandex_compute_instance.srv-db[0].network_interface[0].nat_ip_address
}

output "vm_linux_public_ip_address_2" {
  description = "Virtual machine IP srv-db22"
  value = yandex_compute_instance.srv-db[1].network_interface[0].nat_ip_address
}

output "vm_linux_public_ip_address_3" {
  description = "Virtual machine IP srv-db23"
  value = yandex_compute_instance.srv-db[2].network_interface[0].nat_ip_address
}
output "vm_linux_public_ip_address_admin" {
  description = "Virtual machine srv-caadm"
  value = yandex_compute_instance.ca-adm.network_interface[0].nat_ip_address
}
output "vm_linux_public_ip_address_haproxy" {
  description = "Virtual machine srv-haproxy"
  value = yandex_compute_instance.srv-haproxy35.network_interface[0].nat_ip_address
}
