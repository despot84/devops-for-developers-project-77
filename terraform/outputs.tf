output "vm_id" {
  description = "ID of the created virtual machine"
  value       = hyperv_machine_instance.vm.id
}

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = hyperv_machine_instance.vm.name
}

# output "available_switches" {
#   description = "Available network switches"
#   value       = data.hyperv_network_switch.default
# }

output "vm_info" {
  value = "VM '${hyperv_machine_instance.vm.name}' will be created with disk at '${hyperv_vhd.vm_disk.path}'"
}