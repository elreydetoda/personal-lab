variable "handles" {
  type = set(string)
  description = "File name (e.g. /etc/apt/sources.list)"
  validation {
    condition = alltrue(
      [
        for v in var.handles: contains([
          "ceph-quincy-enterprise",
          "ceph-quincy-no-subscription",
          "ceph-quincy-test",
          "ceph-reef-enterprise",
          "ceph-reef-no-subscription",
          "ceph-reef-test",
          "ceph-squid-enterprise",
          "ceph-squid-no-subscription",
          "ceph-squid-test",
          "enterprise",
          "no-subscription",
          "test"
        ], v)
      ]
    )
    error_message = "Accepted values are: ceph-quincy-enterprise, ceph-quincy-no-subscription, ceph-quincy-test, ceph-reef-enterprise, ceph-reef-no-subscription, ceph-reef-test, ceph-squid-enterprise, ceph-squid-no-subscription, ceph-squid-test, enterprise, no-subscription, test"
  }
}

variable "tgt_node" {
  type = string
  description = "Target proxmox node to deploy vm to."
}

variable "enabled" {
  type = bool
  description = "If repo is enabled (default: true)"
  default = true
}