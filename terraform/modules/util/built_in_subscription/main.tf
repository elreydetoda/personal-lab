
resource "proxmox_virtual_environment_apt_standard_repository" "repo" {
  for_each = var.handles
  handle   = each.value
  node     = var.tgt_node
}

resource "proxmox_virtual_environment_apt_repository" "repo" {
  for_each  = proxmox_virtual_environment_apt_standard_repository.repo
  enabled   = var.enabled
  file_path = each.value.file_path
  index     = each.value.index
  node      = each.value.node
}