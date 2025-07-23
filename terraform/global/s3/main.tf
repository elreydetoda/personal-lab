provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "elrey-homelab"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }
}

# https://github.com/hashicorp/terraform-provider-aws/blob/5f65851b699a7d95f321ea1ec7222e8e94608172/website/docs/r/s3_bucket_versioning.html.markdown?plain=1#L23-L41
# Enable versioning so we can see the full revision history of our
# state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# https://github.com/hashicorp/terraform-provider-aws/blob/5f65851b699a7d95f321ea1ec7222e8e94608172/website/docs/r/s3_bucket_server_side_encryption_configuration.html.markdown?plain=1#L17-L37
# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "elrey-homelab-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
