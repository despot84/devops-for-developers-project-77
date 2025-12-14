output "load_balancer_url" {
  description = "URL to access the application"
  value       = "http://${yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address}"
}

output "dns_url" {
  description = "DNS URL"
  value       = "http://${var.domain_name}"
}

output "app_servers_ips" {
  description = "Internal IPs of application servers"
  value = [
    for instance in yandex_compute_instance.app-server :
    "${instance.name}: ${instance.network_interface[0].ip_address}:${var.app_port}"
  ]
}

output "balancer_ip" {
  description = "External IP of the load balancer"
  value       = yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address
}