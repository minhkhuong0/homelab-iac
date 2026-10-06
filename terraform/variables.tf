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

variable "k3s_servers" {
  type = map(object({
    node_name = string
    vm_id = optional(number, 9000)
    memory = number
    cpu = number
    ip = string
  }))
}
