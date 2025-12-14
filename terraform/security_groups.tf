# Balancer security group - разрешает входящий трафик
resource "yandex_vpc_security_group" "devops-sg-balancer" {
  name        = "devops-sg-balancer"
  description = "Security group for Balancer"
  network_id  = yandex_vpc_network.devops-network.id

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"
    description       = "healthchecks"
    port              = 30080
    predefined_target = "loadbalancer_healthchecks"
  }

  # Разрешаем балансировщику обращаться к приложениям
  egress {
    protocol       = "TCP"
    description    = "to-app-servers"
    port           = var.app_port
    v4_cidr_blocks = ["192.168.0.0/24"]
  }

  egress {
    protocol       = "ANY"
    description    = "outgoing-traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# App servers security group - разрешает трафик и от балансировщика, и напрямую
resource "yandex_vpc_security_group" "devops-sg-appservers" {
  name        = "devops-sg-appservers"
  description = "Security group for App Servers"
  network_id  = yandex_vpc_network.devops-network.id

  # SSH доступ
  ingress {
    protocol       = "TCP"
    description    = "SSH access"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # ДОСТУП НАПРЯМУЮ к приложению из внешней сети (для прямого доступа)
  ingress {
    protocol       = "TCP"
    description    = "Direct app access"
    port           = var.app_port
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Трафик от балансировщика (внутренний)
  ingress {
    protocol       = "TCP"
    description    = "from-balancer"
    port           = var.app_port
    v4_cidr_blocks = ["192.168.0.0/24"]
  }

  # Health checks от Yandex Cloud
  ingress {
    protocol       = "TCP"
    description    = "healthchecks"
    port           = 30080
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  # Исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "internet-access"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Доступ к PostgreSQL
  egress {
    protocol       = "TCP"
    description    = "to-postgresql"
    port           = 6432
    v4_cidr_blocks = ["192.168.0.0/24"]
  }
}

resource "yandex_vpc_security_group" "devops-sg-sql" {
  name        = "devops-sg-sql"
  description = "Security group for PostgreSQL cluster"
  network_id  = yandex_vpc_network.devops-network.id

  ingress {
    protocol       = "TCP"
    description    = "from-app-servers"
    port           = 6432
    v4_cidr_blocks = ["192.168.0.0/24"]
  }
}