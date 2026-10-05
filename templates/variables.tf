# variable "ve_username" {
#   description = "username for Proxmox VE"
#   type        = string
# }
#
# variable "ve_password" {
#   description = "password for Proxmox VE"
#   type        = string
# }

variable "ve_api_token" {
  description = "api token for Prxmox VE"
  type        = string
}

variable "ve_node_name" {
  description = "node to provision template"
  type        = string
  default = "pve"
}

variable "lvm_id" {
  description = "datastore id for vms"
  type        = string
  default = "local-lvm"
}

variable "storage_id" {
  description = "datastore id for storage"
  type        = string
  default = "local"
}
