variable "f_name" {
  type = string
  description = "File name"
}

variable "tgt_node" {
  type = string
  description = "Target proxmox node to deploy vm to."
}

variable "url" {
  type = string
  description = "URL to download from"
}

variable "datastore_id" {
  type = string
  description = "Datastore to save image to (default: local)"
  default = "local"
}