# Terraform Local Variables

In this section we will look at how to use local variables in Terraform.

## Terraform Local Variables - pros

- Allows you to pass information into Terraform
- Allows you to reuse the same Terraform configuration with different values

## Terraform Local Variables - cons

- Requires additional configuration

## Terraform Local Variables - example

In this example, we will be creating a resource group in Azure. We will be using a local variable to pass the name of the resource group into Terraform.

### Terraform Local Variables - example - variables.tf

Creating variable files is a best practice, this allows you to keep all of your variables in one place.

Variable `resource_group_name` is of type `string` and has a default value of `tamopsrg`.

```terraform

variable "resource_group_name" {
  type = string
  default = "tamopsrg"
}

```