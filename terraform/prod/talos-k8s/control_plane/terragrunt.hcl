terraform {
  source = "../../../modules/servers/talos_vm"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  server_vars = read_terragrunt_config(find_in_parent_folders("server.hcl"))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "talos_img" {
  config_path = "../../../global/downloads/talos"
}

inputs = {
  env = local.environment_vars.locals.environment
  # base vm id + the first service
  vmid = local.environment_vars.locals.base_vmid
  tgt_node = local.server_vars.locals.target_node
  node_count = 3
  talos_worker_node = false
  base_name = "pokemon-palace"
  disk_file_id = dependency.talos_img.outputs.id
  ip_config = {
    ipv4 = {
      addresses = [
        "172.16.101.0/23",
        "172.16.101.1/23",
        "172.16.101.2/23"
      ]
      gateway = "172.16.100.1"
    }
  }
}