# https://blog-devops.obiwan.xyz/posts/talos-ha-cluster-with-3-3-nodes-on-proxmox/
resource "proxmox_virtual_environment_vm" "talos_node" {
  count = var.node_count
  name = "${var.base_name}-${var.env}-${var.talos_worker_node ? "worker" : "cp"}-${count.index}"
  description = "Managed by Terraform"
#   tags        = split(",", "deployed_by-terraform,env-${var.env},${var.tags}")
  node_name   = var.tgt_node
  on_boot     = true
  vm_id       = var.vmid == 0 ? var.vmid : var.vmid + count.index

  cpu {
    # worker nodes get 5 CPU cores & control plane gets 2
    cores = var.talos_worker_node ? 5 : 2
    type = "x86-64-v2-AES"
  }

  memory {
    # worker nodes get 16GB cores & control plane gets 4GB
    dedicated = var.talos_worker_node ? 15360 : 4096
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = var.nic
    vlan_id = var.talos_worker_node ? 30 : 100
  }

  disk { # this will be your system disk
    datastore_id = "local-lvm"
    file_id      = var.disk_file_id
    file_format  = "raw"
    interface    = "virtio0"
    size         = var.disk_size
  }
  

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = var.ip_config.ipv4.addresses[0] != "dhcp" ? var.ip_config.ipv4.addresses[count.index] : "dhcp"
        gateway = try(var.ip_config.ipv4.gateway, null)
      }

      ipv6 {
        address = try(
          var.ip_config.ipv6.addresses[0] != "dhcp" ? var.ip_config.ipv6.addresses[count.index] : "dhcp",
          null
        )
        gateway = try(var.ip_config.ipv6.gateway, null)
      }
    }
  }
}
