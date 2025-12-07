# Data source для получения информации о существующем свитче
data "hyperv_network_switch" "default_switch" {
  # name = "Default Switch"
  name = "VMware Network Adapter VMnet8"
  allow_management_os = true
}

# Создание VHD диска
resource "hyperv_vhd" "vm_disk" {
  # path = "E:\\Hyper-V\\${var.vm_name}\\system.vhdx"
  path = "/mnt/e/Hyper-V/${var.vm_name}/system.vhdx"
  size = var.disk_size_gb * 1024 * 1024 * 1024
}

# Создание виртуальной машины
resource "hyperv_machine_instance" "vm" {
  name = var.vm_name
  
  # Процессор и память
  processor_count      = var.vm_cpu_count
  static_memory        = true
  memory_startup_bytes = var.vm_memory_gb * 1024 * 1024 * 1024
  
  # Диски
  hard_disk_drives {
    path = hyperv_vhd.vm_disk.path
    controller_type = "IDE"
    controller_number = 0
    controller_location = 0
  }
  
  # Сетевой адаптер
  network_adaptors {
    name = "Network Adapter"
    switch_name = data.hyperv_network_switch.default_switch.name
  }
  
  # Настройки
#   wait_for_ips = false
}