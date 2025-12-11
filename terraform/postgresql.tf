resource "yandex_mdb_postgresql_cluster" "postgresql588" {
  name                = "postgresql588"
  environment         = "PRODUCTION"
  network_id          = yandex_vpc_network.devops-network.id
  security_group_ids  = [yandex_vpc_security_group.devops-sg-sql.id]
  deletion_protection = false

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 22
  }

  config {
    version = 15
    resources {
      resource_preset_id = "c3-c2-m4" # 2 vCPU, 4GB RAM
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }
  }

  host {
    zone             = var.yc_zone
    name             = "PostgreSQL"
    subnet_id        = yandex_vpc_subnet.devops-subnet.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_postgresql_user" "db_user" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql588.id
  name       = var.db_user
  password   = var.db_password
}

resource "yandex_mdb_postgresql_database" "db_name" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql588.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.db_user.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"

  depends_on = [yandex_mdb_postgresql_user.db_user]
}