# Terraform Basic Commands

Lets look at the basic commands you shuld know to begin working with and deploying Terraform. Throughout I may add some further but to begin, have a look at understanding of these!

## Terraform Version

Check the version of Terraform you are running using: `terraform -v`

```bash
terraform -v 
```

## Terraform Init

Terraform init is used to initialise terarform and prepare your working directory and downtime the relevant providers etc.

```bash
terraform init
```

## Terraform Validate

A great command to have, validates the terraform configuration in the current directory. Great to use in terms of checking syntax and configuration is correct.

```bash
terraform validate
```

## Terraform Plan

Creates and shows a Plan of your Terraform configuration, this includes additions, updates and removals.

```bash
terraform plan
```

## Terraform apply

Applies the Terraform configuration, in this case - it will be applying Terraform configuration that will deploy into Azure.

```bash
terraform apply
```

## Terraform Destroy

Used to destroy a Terraform configuration, when you run this command successfully - it will also destroy the resources in Azure.

```bash
terraform destroy
```

## Terraform Format

Formats current directory with Terraform/HCL standards.

```bash
terraform fmt
```