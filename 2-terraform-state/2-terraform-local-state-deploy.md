# Terraform Deploy using Local State file 

Review directory [local-state-example](https://github.com/thomast1906/terraform-on-azure/tree/main/2-terraform-state/local-state-example) and the Terraform configuration files.

Notice the reference to terraform backend in provider.tf

```terraform
terraform {
  backend "local" {
  }
}
```

This is telling Terraform to use the local state file.

## Terraform init

Run the following command to initialise Terraform when in the local-state-example directory:

```terraform
terraform init
```

## Terraform plan

Run the following command to create and show a plan of your Terraform configuration:

```terraform
terraform plan
```

A successful plan will look like the following:

```terraform
thomast@MGH97DTW40 local-state-example % terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "tamopslocalrg"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

## Terraform apply

Run the following command to apply the Terraform configuration:

```terraform
terraform apply
```

A successful apply will look like the following:

```terraform
thomast@MGH97DTW40 local-state-example % terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "tamopslocalrg"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

Review the output of the apply command, notice the following:

```terraform
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## Terraform destroy

Run the following command to destroy the Terraform configuration:

```terraform
terraform destroy
```

A successful destroy will look like the following:

```terraform
thomast@MGH97DTW40 local-state-example % terraform destroy
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tamopslocalrg]
azurerm_resource_group.rg: Destroying... [id=/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tamopslocalrg]
azurerm_resource_group.rg: Destruction complete after 1s

Destroy complete! Resources: 1 destroyed.
```



