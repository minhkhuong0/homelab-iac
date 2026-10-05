data "terraform_remote_state" "templates" {
  backend = "local"

  config = {
    path = "../templates/terraform.tfstate"
  }
}

locals {
  k3s_defaults = {
    vm_id = data.terraform_remote_state.templates.outputs.debian_template_vm_id
  }
  k3s_servers = {
    for name, server in var.k3s_servers:
      name => merge(local.k3s_defaults, server)
  }
}

resource "proxmox_virtual_environment_vm" "k3s_server" {
  for_each = var.k3s_servers

  name      = each.key
  node_name = each.value.node_name

  clone {
    vm_id = each.value.vm_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu
  }

  memory {
    dedicated = each.value.memory
  }

  initialization {
    dns {
      servers = ["10.42.0.2"]
    }
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = "10.42.0.1"
      }
    }
  }
}
