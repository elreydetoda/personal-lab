terraform {
  source = "../../../modules/util/built_in_subscription"
}

locals {
  server_vars = read_terragrunt_config(find_in_parent_folders("server.hcl"))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  tgt_node = local.server_vars.locals.target_node
  handles = ["no-subscription"]
}