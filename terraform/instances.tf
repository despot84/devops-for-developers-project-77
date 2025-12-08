# # Создание VHD диска
resource "hyperv_vhd" "vm_disk1" {
  path = "C:\\Hyper-V\\app-server-1-disk.vhdx"
  size = 5 * 1024 * 1024 * 1024
}

# resource "hyperv_vhd" "vm_disk2" {
#   path = "C:\\Hyper-V\\app-server-2-disk.vhdx"
#   size = var.disk_size_gb * 1024 * 1024 * 1024
# }

# # Data source для получения информации о существующем свитче
data "hyperv_network_switch" "default" {
  name                                    = "Default Switch"
  notes                                   = ""
  allow_management_os                     = true
  enable_embedded_teaming                 = false
  enable_iov                              = false
  enable_packet_direct                    = false
  minimum_bandwidth_mode                  = "None"
  switch_type                             = "Internal"
  net_adapter_names                       = []
  default_flow_minimum_bandwidth_absolute = 0
  default_flow_minimum_bandwidth_weight   = 0
  default_queue_vmmq_enabled              = false
  default_queue_vmmq_queue_pairs          = 16
  default_queue_vrss_enabled              = false
}

resource "hyperv_machine_instance" "app_server_1" {
  name                 = "app-server-1"
  generation           = 1
  
  # Путь к папке ВМ
  path                 = "C:\\Hyper-V"

  # Память
  static_memory        = true
  memory_startup_bytes = 1 * 1024 * 1024 * 1024

  # Процессор
  processor_count      = 1

  network_adaptors {
    name        = "Network Adapter"
    switch_name = data.hyperv_network_switch.default.name
  }
  
  # Configure firmware
  vm_firmware {
    enable_secure_boot              = "Off"  # Отключаем Secure Boot для Linux
    console_mode                    = "Default"

    #secure_boot_template            = ""
    preferred_network_boot_protocol = "IPv4"
    # pause_after_boot_failure        = "Off"
    boot_order {
      boot_type           = "HardDiskDrive"
      controller_number   = "0"
      controller_location = "0"
    }
  }
  # Configure processor
  vm_processor {
    compatibility_for_migration_enabled               = false
    compatibility_for_older_operating_systems_enabled = false
    maximum                                           = 100
    reserve                                           = 0
    relative_weight                                   = 100
  }

  # Диски
  hard_disk_drives {
    path = hyperv_vhd.vm_disk1.path
    controller_type = "SCSI"
    controller_number = 0
    controller_location = 0
  }

  # Важные настройки для Linux на Hyper-V
  automatic_start_action          = "StartIfRunning"
  automatic_stop_action           = "Save"
  automatic_start_delay           = 0
  automatic_critical_error_action = "Pause"  # Исправлено: строка вместо enum
  checkpoint_type                 = "Disabled"
  
  # Для Linux лучше отключить гостевые кэши
  guest_controlled_cache_types = false
}

# # resource "hyperv_machine_instance" "app_server_2" {
# #   name               = "app-server-2"
# #   memory_size        = 1024 # in Mb
# #   cpu_count          = 1
# #   network_adapter {
# #     name = "Network Adapter"
# #   }
  
# #   disk {
# #     name    = "app-server-2-disk.vhdx"
# #     size    = 5 # in GB
# #     type    = "Dynamic"
# #     host_path = "${path.module}/app-server-2-disk.vhdx" # Adjust as needed
# #   }

# #   cloud_init {
# #     user_data = <<-EOF
# #       #cloud-config
# #       users:
# #         - name: ${var.vm_login}
# #           sudo: ALL=(ALL) NOPASSWD:ALL
# #           shell: /bin/bash
# #           ssh_authorized_keys:
# #             - ${file(var.ssh_pub_key_path)}
# #     EOF
# #   }

# # #   depends_on = [hyperv_machine_instance.terra_db, hyperv_machine_instance.db_name]
# # }