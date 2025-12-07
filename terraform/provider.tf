terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 1.0"
    }
  }

  required_version = ">= 0.13"
}

provider "hyperv" {
  # Способ 1: Локальный Hyper-V (по умолчанию)
  # Не требует дополнительных настроек для локального хоста

  # # Способ 2: Удаленный Hyper-V через WinRM
  host        = (var.hyperv_host)
  port        = (var.hyperv_port)
  user        = (var.hyperv_user)
  password    = (var.hyperv_password)
  https       = (var.hyperv_https)
  insecure    = (var.hyperv_insecure)
  use_ntlm    = (var.hyperv_use_ntlm)
  script_path = (var.hyperv_script_path)
  timeout     = (var.hyperv_timeout)
  
  # tls_insecure = true

  # # Способ 3: Через SSH не работает
  # ssh_user = var.hyperv_user
  # ssh_password = var.hyperv_password
  # ssh_port = var.hyperv_ssh_port
}
