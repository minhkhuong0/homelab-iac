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
  default = "tank"
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

variable "ve_nodes" {
  description = "nodes in the proxmox cluster"
  type = map
}
variable "storage_node" {
  description = "node that download and create files"
  type = string
  default = "pve2"
}
