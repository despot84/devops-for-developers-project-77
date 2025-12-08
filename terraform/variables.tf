variable "hyperv_host" {
  description = "Hyper-V host address"
  type        = string
  default     = "localhost"
}

variable "hyperv_port" {
  description = "Hyper-V WinRM port"
  type        = number
  default     = 5985
}

variable "hyperv_ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}


variable "hyperv_user" {
  description = "Hyper-V username"
  type        = string
  default     = "ServiceAccount"
}

variable "hyperv_password" {
  description = "Hyper-V password"
  type        = string
  sensitive   = true
#   default     = null
}

variable "hyperv_https" {
  description = "Use HTTPS for WinRM"
  type        = bool
  default     = false
}

variable "hyperv_insecure" {
  description = "Allow insecure WinRM connections"
  type        = bool
  default     = false
}

variable "hyperv_use_ntlm" {
  description = "Use NTLM authentication"
  type        = bool
  default     = false
}

variable "hyperv_script_path" {
  description = "Path to store scripts on Hyper-V host"
  type        = string
  default     = "C:/Temp/terraform"
}

variable "hyperv_timeout" {
  description = "Timeout for Hyper-V operations"
  type        = string
  default     = "30s"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "terraform-vm"
}

variable "iso_path" {
  description = "Path to ISO file for installation"
  type        = string
  default     = "S:\\Distrib\\OS\\ubuntu-24.04.3-desktop-amd64.iso"
}

variable "vm_memory_gb" {
  description = "VM memory in GB"
  type        = number
  default     = 2
}

variable "vm_cpu_count" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 2
}

variable "disk_size_gb" {
  description = "System disk size in GB"
  type        = number
  default     = 40
}

variable "datadog_api_key" {
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  type        = string
  default     = "https://api.datadoghq.eu"
}
