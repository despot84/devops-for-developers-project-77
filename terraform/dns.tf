resource "yandex_dns_zone" "prod-zone" {
  name        = "prod-zone"
  description = "Production DNS zone for ${var.domain_name}"
  zone        = "${var.domain_name}."
  # public      = true
}

resource "yandex_dns_recordset" "alb-record" {
  zone_id = yandex_dns_zone.prod-zone.id
  name    = "${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address]
}