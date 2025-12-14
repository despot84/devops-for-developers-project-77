resource "yandex_compute_instance" "app-server" {
  count              = var.yc_instance_count
  name               = "app-server-${count.index + 1}"
  hostname           = "app-server-${count.index + 1}"
  platform_id        = "standard-v3"
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
    preemptible = true
  }

  # Явно указываем зависимости
  depends_on = [
    yandex_vpc_security_group.devops-sg-appservers,
    yandex_vpc_security_group.devops-sg-sql,
    yandex_mdb_postgresql_cluster.postgresql588
  ]
}