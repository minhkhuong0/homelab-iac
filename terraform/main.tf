resource "proxmox_virtual_environment_vm" "vms" {
  for_each = var.vms

  name      = each.key
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
    #file_id      = proxmox_download_file.debian_cloud_image[each.key].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = each.value.disk_size
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
