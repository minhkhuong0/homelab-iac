resource "proxmox_virtual_environment_vm" "k3s_server" {
  depends_on = [
    proxmox_virtual_environment_vm.debian_template
  ]
  for_each = var.k3s_servers

  name      = each.key
  node_name = each.value.node_name

  clone {
    vm_id = each.value.template_vm_id
    node_name = var.template_node
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
