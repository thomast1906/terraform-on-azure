# Terraform State - Local vs Remote

Terraform state is a file that is used to keep track of the resources that have been created by Terraform. This file is used to keep track of the resources that have been created, and also to keep track of the state of the resources that have been created.

# Terraform local state

Terraform local state is the default state that Terraform uses. This state is stored locally on the machine that Terraform is being run on. This state is stored in a file called `terraform.tfstate`. This file is stored in the same directory that Terraform is being run from.

## Terraform local state - pros

- Simple to use
- No additional configuration required

## Terraform local state - cons

- Not recommended for production use
- Not recommended for use with multiple users
- Not recommended for use with multiple Terraform workspaces

# Terraform remote state

Terraform remote state is a state that is stored remotely. This state is stored in a remote location, in this case - it will be an Azure Storage Account.

## Terraform remote state - pros

- Recommended for production use
- Recommended for use with multiple users
- Recommended for use with multiple Terraform workspaces

## Terraform remote state - cons

- Requires additional configuration
- Requires additional cost
