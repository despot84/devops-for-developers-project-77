# Application Load Balancer
resource "yandex_alb_load_balancer" "app_balancer" {
  name        = "app-balancer"
  network_id  = yandex_vpc_network.devops-network.id

  allocation_policy {
    location {
      zone_id   = var.yc_zone
      subnet_id = yandex_vpc_subnet.devops-subnet.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.devops-alb-ip.external_ipv4_address[0].address
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.app_router.id
      }
    }
  }

  security_group_ids = [yandex_vpc_security_group.devops-sg-balancer.id]
}

# HTTP router
resource "yandex_alb_http_router" "app_router" {
  name      = "app-router"
}

# Backend group
resource "yandex_alb_backend_group" "app_backend" {
  name = "app-backend-group"

  http_backend {
    name             = "app-backend"
    weight           = 1
    port             = var.app_port
    target_group_ids = [yandex_alb_target_group.app_targets.id]

    load_balancing_config {
      panic_threshold = 50
    }

    healthcheck {
      timeout             = "3s"
      interval            = "5s"
      healthy_threshold   = 1
      unhealthy_threshold = 3
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# Target group
resource "yandex_alb_target_group" "app_targets" {
  name = "app-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.app-server
    content {
      subnet_id  = yandex_vpc_subnet.devops-subnet.id
      ip_address = target.value.network_interface[0].ip_address
    }
  }
}

# Virtual host
resource "yandex_alb_virtual_host" "app_vhost" {
  name           = "app-vhost"
  http_router_id = yandex_alb_http_router.app_router.id
  # authority      = [var.domain_name]

  route {
    name = "main-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.app_backend.id
        timeout          = "3s"
      }
    }
  }
}