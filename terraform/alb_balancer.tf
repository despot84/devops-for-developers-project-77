resource "yandex_cm_certificate" "alb_cert" {
  name          = "devops-alb-letsencrypt"

  self_managed {
    certificate = file(var.tls_fullchain_pem_path)
    private_key = file(var.tls_privkey_pem_path)
  }
}

resource "yandex_alb_target_group" "devops-tg" {
  name           = "devops-tg"

  target {
    subnet_id    = yandex_vpc_subnet.devops-subnet.id
    ip_address = yandex_compute_instance.app-server-1.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.devops-subnet.id
    ip_address = yandex_compute_instance.app-server-2.network_interface.0.ip_address
  }
}

resource "yandex_alb_backend_group" "devops-bg" {
  name = "devops-bg"

  http_backend {
    name                   = "devops-backend"
    weight                 = 1
    port                   = 3000
    target_group_ids       = [yandex_alb_target_group.devops-tg.id]
    healthcheck {
      timeout              = "1s"
      interval             = "1s"
      healthy_threshold    = 1
      unhealthy_threshold  = 1
      healthcheck_port     = 3000
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "devops-router" {
  name          = "devops-router"
}

resource "yandex_alb_virtual_host" "devops-host" {
  name                    = "devops-host"
  http_router_id          = yandex_alb_http_router.devops-router.id

  route {
    name                  = "devops-route"
    http_route {
      http_match  {
        path {
          prefix          = "/"
	      }
      }
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.devops-bg.id
        timeout           = "60s"
	      auto_host_rewrite =  false
      }
    }
  }

  authority = ["devops.allegrohub.ru"]
}

resource "yandex_alb_load_balancer" "devops-alb" {
  name        = "devops-alb"
  network_id  = yandex_vpc_network.devops-network.id
  security_group_ids = [yandex_vpc_security_group.devops-sg-balancer.id]

  allocation_policy {
    location {
      zone_id   = var.yc_zone
      subnet_id = yandex_vpc_subnet.devops-subnet.id
    }
  }

  listener {
    name = "devops-listener-http"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address
        }
      }
      ports = [80]
    }
    http {
      redirects {
        http_to_https = true
      }
    }
  }

  listener {
    name = "devops-listener-https"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address
        }
      }
      ports = [443]
    }
    tls {
      default_handler {
        http_handler {
          http_router_id = yandex_alb_http_router.devops-router.id
        }
        certificate_ids = [yandex_cm_certificate.alb_cert.id]
      }
      sni_handler {
        name = "devops-sni"
        server_names = ["devops.allegrohub.ru"]
        handler {
          http_handler {
            http_router_id = yandex_alb_http_router.devops-router.id
          }
          certificate_ids = [yandex_cm_certificate.alb_cert.id]
        }
      }
    }
  }

  log_options {
    disable = true
  }
}