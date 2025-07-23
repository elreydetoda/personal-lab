resource "proxmox_virtual_environment_download_file" "install_image" {
  content_type            = "iso"
  datastore_id            = var.datastore_id
  node_name               = var.tgt_node

  file_name               = var.f_name
  url                     = var.url
  decompression_algorithm = "gz"
  overwrite               = true
}