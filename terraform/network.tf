resource "yandex_vpc_network" "devops-network" {
  name      = "devops-network"
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_subnet" "devops-subnet" {
  name           = "devops-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.devops-network.id
  v4_cidr_blocks = ["192.168.0.0/24"]
  folder_id      = var.yc_folder_id
}

resource "yandex_vpc_address" "devops-alb-ip" {
  name = "devops-alb-ip"

  external_ipv4_address {
    zone_id = var.yc_zone
  }
}