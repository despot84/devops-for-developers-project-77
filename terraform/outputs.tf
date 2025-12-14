output "load_balancer_url" {
  description = "URL to access the application via load balancer"
  value       = "http://${yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address}"
}

output "load_balancer_https_url" {
  description = "HTTPS URL to access the application via load balancer"
  value       = "https://${var.domain_name}"
}

output "dns_url" {
  description = "DNS URL"
  value       = "http://${var.domain_name}"
}

output "balancer_ip" {
  description = "External IP of the load balancer"
  value       = yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address
}

output "app_servers_internal_ips" {
  description = "Internal IPs of application servers"
  value = [
    for instance in yandex_compute_instance.app-server :
    "${instance.name}: ${instance.network_interface[0].ip_address}:${var.app_port}"
  ]
}

output "app_servers_direct_urls" {
  description = "Direct URLs to access application servers"
  value = [
    for instance in yandex_compute_instance.app-server :
    "http://${instance.network_interface[0].nat_ip_address}:${var.app_port}"
  ]
}

output "app_servers_public_ips" {
  description = "Public IPs of application servers for direct access"
  value = [
    for instance in yandex_compute_instance.app-server :
    "${instance.name}: ${instance.network_interface[0].nat_ip_address}"
  ]
}

# Удобный вывод в виде map
output "access_methods" {
  description = "All available access methods"
  value = {
    load_balancer = {
      http  = "http://${yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address}"
      https = "https://${var.domain_name}"
      dns   = "http://${var.domain_name}"
    }
    direct_access = {
      for idx, instance in yandex_compute_instance.app-server :
      instance.name => "http://${instance.network_interface[0].nat_ip_address}:${var.app_port}"
    }
  }
}