data "terraform_remote_state" "templates" {
  backend = "local"

  config = {
    path = "../templates/terraform.tfstate"
  }
}
resource "proxmox_virtual_environment_vm" "dns_server" {
  name      = "dns-server"
  node_name = var.ve_node_name
  vm_id     = 100 # TODO:change later to 102

  clone {
    vm_id = data.terraform_remote_state.templates.outputs.debian_template_vm_id
  }

  agent {
    enabled = true
  }

  memory {
    dedicated = 1024
  }

  initialization {
    dns {
      servers = ["10.42.0.1"]
    }
    ip_config {
      ipv4 {
        address = "10.42.0.2/24"
        gateway = "10.42.0.1"
      }
    }
  }
}
