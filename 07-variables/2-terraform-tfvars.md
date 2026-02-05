# Use variable files

Variable files let you separate configuration values from your Terraform code. This keeps sensitive values out of version control and makes it easy to manage different environments.

## Create a tfvars file

Create `terraform.tfvars`:

```terraform
resource_group_name = "rg-prod-app"
location            = "uksouth"
environment         = "production"

tags = {
  ManagedBy   = "Terraform"
  Environment = "Production"
  CostCenter  = "Engineering"
}
```

Terraform automatically loads files named `terraform.tfvars` or `*.auto.tfvars`.

## Define your variables

In `variables.tf`, declare the variables without default values:

```terraform
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
```

## Use the variables

In `main.tf`:

```terraform
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

## Deploy

Terraform picks up `terraform.tfvars` automatically:

```bash
terraform apply
```

## Manage multiple environments

Create separate files for each environment:

`dev.tfvars`:
```terraform
resource_group_name = "rg-dev-app"
location            = "uksouth"
environment         = "development"

tags = {
  ManagedBy   = "Terraform"
  Environment = "Development"
}
```

`prod.tfvars`:
```terraform
resource_group_name = "rg-prod-app"
location            = "uksouth"
environment         = "production"

tags = {
  ManagedBy   = "Terraform"
  Environment = "Production"
}
```

Deploy to dev:
```bash
terraform apply -var-file="dev.tfvars"
```

Deploy to prod:
```bash
terraform apply -var-file="prod.tfvars"
```

## Keep secrets out of version control

Never commit sensitive values to git. Create a `.gitignore`:

```
# Terraform state files
*.tfstate
*.tfstate.backup

# Variable files with secrets
*.tfvars
!example.tfvars

# Terraform directory
.terraform/
```

For secrets like passwords or keys, use Azure Key Vault (covered in section 5) or environment variables:

```bash
export TF_VAR_admin_password="YourSecretPassword"
terraform apply
```

