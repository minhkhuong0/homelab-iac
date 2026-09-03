resource "proxmox_virtual_environment_vm" "debian_template" {
  name      = "debian-template"
  node_name = var.ve_node_name
  vm_id     = 9000

  template = true
  started  = false

  machine     = "q35"
  bios        = "ovmf"
  description = "Mangaged by Terraform"

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  efi_disk {
    datastore_id = var.lvm_id
    type         = "4m"
  }

  disk {
    datastore_id = var.lvm_id
    file_id      = proxmox_download_file.debian_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_download_file" "debian_cloud_image" {
  content_type = "iso"
  datastore_id = var.storage_id
  node_name    = var.ve_node_name

  url       = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
  file_name = "debian-13-generic-amd64.img"
}
