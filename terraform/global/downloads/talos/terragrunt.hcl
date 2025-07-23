terraform {
  source = "../../../modules/util/download_raw"
}

locals {
  server_vars = read_terragrunt_config(find_in_parent_folders("server.hcl"))
  talos = {
    version = "v1.10.5"
    # customization:
    #   systemExtensions:
    #     officialExtensions:
    #       - siderolabs/iscsi-tools
    #       - siderolabs/qemu-guest-agent
    #       - siderolabs/util-linux-tools
    schema_version = "88d1f7a5c4f1d3aba7df787c448c1d3d008ed29cfb34af53fa0df4336a56040b"
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  url = "https://factory.talos.dev/image/${local.talos.schema_version}/${local.talos.version}/nocloud-amd64.raw.gz"
  f_name = "talos-${local.talos.version}_${local.talos.schema_version}-nocloud-amd64.img"
  tgt_node = local.server_vars.locals.target_node
}