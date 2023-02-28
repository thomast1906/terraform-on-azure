# Terraform tfvars

tfvars files are used to store variables that are used in Terraform. These files are used to store sensitive information such as passwords and keys. These files are not stored in the repository and are ignored by git.

## Terraform tfvars - pros

- Recommended for storing sensitive information
- Recommended for storing information that is not to be shared

## Terraform tfvars - cons

- Requires additional configuration
- Requires additional cost

## Terraform tfvars - example

In this example, we will be creating a resource group in Azure. We will be using a tfvars file to pass the name of the resource group into Terraform.

### Terraform tfvars - example - variables.tf

Creating variable files is a best practice, this allows you to keep all of your variables in one place.

Variable `resource_group_name` is of type `string` and has a default value of `tamopsrg`.

```terraform

variable "resource_group_name" {
  type = string
}

```

### Terraform tfvars - example - terraform.tfvars

Notice the reference to the variable `resource_group_name` in the tfvars file. This is used to pass the value `tamopsrg` to the variable `resource_group_name`.

```terraform

resource_group_name = "tamopsrg"

```

### Terraform tfvars - example - main.tf

```terraform

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "uksouth"
}

```

### Terraform tfvars - example - terraform init

Running terraform with the tfvars file is done by using the `-tfvars-file` flag. example below

```terraform

terraform plan -tfvars-file=terraform.tfvars

```

