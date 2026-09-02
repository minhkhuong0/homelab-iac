terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }
}

provider "proxmox" {
  endpoint = "https://10.42.0.10:8006/"
  username = var.ve_username
  password = var.ve_password
  insecure = true
}
