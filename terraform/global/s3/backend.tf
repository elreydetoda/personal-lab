terraform {
  backend "s3" {
    bucket = "elrey-homelab"
    key = "global/s3/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "elrey-homelab-terraform-state-locks"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.4"
    }
  }
}

