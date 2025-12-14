resource "yandex_dns_zone" "prod-zone" {
  name        = "prod-zone"
  description = "Production DNS zone for ${var.domain_name}"
  zone        = "${var.domain_name}."
}

# Запись для балансировщика
resource "yandex_dns_recordset" "alb-record" {
  zone_id = yandex_dns_zone.prod-zone.id
  name    = "${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address]
}

# Wildcard запись для балансировщика
resource "yandex_dns_recordset" "wildcard-record" {
  zone_id = yandex_dns_zone.prod-zone.id
  name    = "*.${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address]
}

# Записи для прямого доступа к каждому серверу (опционально)
resource "yandex_dns_recordset" "app-server-records" {
  count   = var.yc_instance_count
  zone_id = yandex_dns_zone.prod-zone.id
  name    = "app${count.index + 1}.${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.app-server[count.index].network_interface[0].nat_ip_address]
}