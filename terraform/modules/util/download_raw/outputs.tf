output "id" {
  description = "id of the image in the datastore (e.g. local:iso/talos-v1.10.5-nocloud-amd64.img)"
  value = proxmox_virtual_environment_download_file.install_image.id
}