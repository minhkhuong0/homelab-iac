resource "proxmox_virtual_environment_vm" "k3s_server" {
  for_each = var.k3s_servers

  name      = each.key
  tags      = ["terraform", "debian", "k3s-server"]
  node_name = each.value.node_name

  clone {
    vm_id = proxmox_virtual_environment_vm.debian_template[each.value.node_name].vm_id
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

  disk {
    datastore_id = var.lvm_id
    size         = each.value.disk_size
    file_format  = "raw"
    interface    = "virtio1"
    iothread     = true
    discard      = "on"
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
  stop_on_destroy = true
}
