variable "yc_token" {
  description = "OAuth-token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  type      = string
  sensitive = true
}

variable "yc_folder_id" {
  type      = string
  sensitive = true
}

variable "yc_zone" {
  description = "availability zone"
  type        = string
  sensitive   = true
}

variable "yc_service_account_id" {
  type      = string
  sensitive = true
}

variable "vm_login" {
  description = "VM user login"
  type        = string
  sensitive   = true
}

variable "yc_os_image_id" {
  description = "yandex cloud id for Operating System image"
  type        = string
  sensitive   = false
}

variable "ssh_pub_key_path" {
  type      = string
  sensitive = false
}

variable "local_ssh_path" {
  type      = string
  sensitive = false
}

variable "domain_address" {
  type      = string
  sensitive = false
}

variable "vm_admin_username" {
  type      = string
  sensitive = false
}

variable "db_name" {
  type      = string
  sensitive = true
}

variable "db_user" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "tls_fullchain_pem_path" {
  type      = string
  sensitive = true
}

variable "tls_privkey_pem_path" {
  type      = string
  sensitive = true
}

variable "domain_name" {
  type = string
}

variable "datadog_api_key" {
  type      = string
  sensitive = true
}

variable "datadog_app_key" {
  type      = string
  sensitive = true
}

variable "datadog_api_url" {
  type      = string
  sensitive = true
}

variable "datadog_site" {
  type      = string
  sensitive = true
}