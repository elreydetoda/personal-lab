variable "talos_worker_node" {
  type = bool
  description = "Either a worker or control plane nodes for a Talos k8s cluster (control_plane or worker)"
}

variable "node_count" {
  type = number
  description = "Number of talos nodes wanted"
}

variable "env" {
  type = string
  description = "environment getting deployed to ( default: dev )"
  default = "dev"
}

variable "base_name" {
  type = string
  description = "Name of server."
}

variable "vmid" {
  type = number
  description = "VM ID number for server ( default: auto-increment )"
  default = 0
}

variable "tgt_node" {
  type = string
  description = "Target proxmox node to deploy vm to."
}

variable "disk_size" {
  type = string
  description = "size of vm HDD, ( default: 20G )"
  default = 32
}

variable "nic" {
  type = string
  description = "NIC interface for VM ( default: vmbr0 )"
  default = "vmbr0"
}

variable "tags" {
  type = string
  description = "tags to add metadata to server ( default: empty )"
  default = ""
}

variable "disk_file_id" {
  type = string
  description = "disk ID from the raw downloaded image"
}

variable "ip_config" {
  type = object({
    ipv4 = optional(object({
      addresses = list(string) # CIDR strings (e.g., ["172.16.101.0/23","172.16.101.1/23"]) or "dhcp"
      gateway = optional(string)
    }))
    ipv6 = optional(object({
      addresses = list(string)
      gateway = optional(string)
    }))
  })
  description = "Network configuration values"
  default = {
    ipv4 = {
      # address = "${var.talos_cp_01_ip_addr}/23"
      addresses = ["dhcp"]
      # gateway = var.default_gateway
      },
    ipv6 = {
      addresses = ["dhcp"]
    }
  }
}