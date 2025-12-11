resource "local_file" "ansible_inventory" {
  content = templatefile("../ansible/inventory.ini.template", {
    app_server_1_ip = yandex_compute_instance.app-server-1.network_interface.0.nat_ip_address
    app_server_2_ip = yandex_compute_instance.app-server-2.network_interface.0.nat_ip_address
    app_server_user = var.vm_login
    app_server_keypath = var.ssh_pub_key_path
  })
  filename = "../ansible/inventory.ini"
}