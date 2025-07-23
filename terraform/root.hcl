# Taken from: https://github.com/gruntwork-io/terragrunt-infrastructure-live-stacks-example/blob/14d6c60246c39cb3aeae75c49202ea7185ae5b3f/root.hcl

# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform/OpenTofu that provides extra tools for working with multiple modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # utilized when targeting a specific proxmox node
  server_vars = read_terragrunt_config(find_in_parent_folders("server.hcl"))
}

# Generate an Proxmox provider block
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "proxmox" {
  insecure = true
  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs#ssh-connection
  ssh {
    # eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa
    agent = true
  }
  # pm_log_enable = true
  # pm_log_file = "terraform-plugin-proxmox.log"
  # pm_log_levels = {
  #   _default = "debug"
  #   _capturelog = ""
  # }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "elrey-homelab"
    key            = "${path_relative_to_include()}/tf.tfstate"
    region         = "us-west-2"
    dynamodb_table = "elrey-homelab-terraform-state-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Configure what repositories to search when you run 'terragrunt catalog'
catalog {
  urls = [
    "https://github.com/gruntwork-io/terragrunt-infrastructure-catalog-example",
    "https://github.com/gruntwork-io/terraform-aws-utilities",
    "https://github.com/gruntwork-io/terraform-kubernetes-namespace"
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.server_vars.locals,
)