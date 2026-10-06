resource "proxmox_virtual_environment_vm" "debian_template" {
  for_each = var.ve_nodes

  name      = "debian-template"
  node_name = each.key
  vm_id     = each.value

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
    file_id      = proxmox_download_file.debian_cloud_image[each.key].id
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

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config[each.key].id
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_download_file" "debian_cloud_image" {
  for_each = var.ve_nodes

  content_type = "iso"
  datastore_id = var.storage_id
  node_name    = each.key

  url       = "https://ftp5.gwdg.de/pub/linux/debian/debian-cloud-image/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
  file_name = "debian-13-generic-amd64.img"
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  for_each = var.ve_nodes
  
  content_type = "snippets"
  datastore_id = var.storage_id
  node_name    = each.key

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: test_debian
    timezone: UTC
    users:
      - default
      - name: ansible
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(file("~/.ssh/id_ed25519.pub"))}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}
