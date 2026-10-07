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

variable "vms" {
  type = map(object({
    node_name = string
    vm_id = optional(number, 9000)
    memory = number
    cpu = number
    ip = string
    disk_size = optional(number, 20)
  }))
}

variable "ve_nodes" {
  type = map
}
