resource "proxmox_virtual_environment_vm" "disk_vm" {
  for_each = var.k3s_servers

  name      = "disk-vm"
  tags      = ["terraform", "disk"]
  node_name = each.value.node_name

  started = false
  on_boot = false

  disk {
    datastore_id = var.lvm_id
    interface    = "virtio0"
    file_format  = "raw"
    size         = each.value.disk_size
    iothread     = true
    discard      = "on"
  }

  lifecycle {
    prevent_destroy = true
  }
}
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
    datastore_id      = var.lvm_id
    file_format       = "raw"
    size              = each.value.disk_size
    path_in_datastore = proxmox_virtual_environment_vm.disk_vm[each.key].disk[0].path_in_datastore
    interface         = "virtio1"
    iothread          = true
    discard           = "on"
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
