terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://10.42.0.10:8006/"
  api_token = var.ve_api_token
  insecure  = true

  ssh {
    agent    = true
    username = "root"
  }
}
