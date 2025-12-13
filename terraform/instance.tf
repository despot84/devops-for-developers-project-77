resource "yandex_compute_instance" "app-server-1" {
  name               = "app-server-1"
  hostname           = "app-server-1"
  platform_id        = "standard-v3" # Intel Ice Lake
  zone               = var.yc_zone
  service_account_id = var.yc_service_account_id

  resources {
    cores         = 2
    core_fraction = 50
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_os_image_id
      size     = 15
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.devops-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.devops-sg-appservers.id]
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      datasource:
        Ec2:
          strict_id: false
      ssh_pwauth: no
      users:
        - name: ${var.vm_login}
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file(var.ssh_pub_key_path)}
      EOF
  }

  scheduling_policy {
    preemptible = true # прерываемая ВМ
  }

  depends_on = [yandex_mdb_postgresql_cluster.postgresql588, yandex_mdb_postgresql_database.db_name]
}

resource "yandex_compute_instance" "app-server-2" {
  name               = "app-server-2"
  hostname           = "app-server-2"
  platform_id        = "standard-v3" # Intel Ice Lake
  zone               = var.yc_zone
  service_account_id = var.yc_service_account_id

  resources {
    cores         = 2
    core_fraction = 50
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_os_image_id
      size     = 15
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.devops-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.devops-sg-appservers.id]
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      datasource:
        Ec2:
          strict_id: false
      ssh_pwauth: no
      users:
        - name: ${var.vm_login}
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file(var.ssh_pub_key_path)}
      EOF
  }

  scheduling_policy {
    preemptible = true # прерываемая ВМ
  }

  depends_on = [yandex_mdb_postgresql_cluster.postgresql588, yandex_mdb_postgresql_database.db_name]
}