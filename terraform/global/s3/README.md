Initially have everything in the backend.tf file commented out, and you'll use local state with a manual `terraform apply` command.

After creating the s3 & Dynamo table, then uncomment the backend.tf & do a `terraform init`. It'll prompt for migrating to the new backend you just created