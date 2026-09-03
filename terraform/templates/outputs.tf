output "debian_template_vm_id" {
  value       = proxmox_virtual_environment_vm.debian_template.vm_id
  description = "The ID of the genertaed template VM"
}
