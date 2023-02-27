# Terraform Deploy using Remote State file 

Review directory [remote-state-example](https://github.com/thomast1906/terraform-on-azure/tree/main/2-terraform-state/remote-state-example) and the Terraform configuration files.

## Create remote state storage account

Create a storage account to store the remote state file.
1. Edit the [variables](https://github.com/thomast1906/terraform-on-azure/tree/main/2-terraform-state/scripts/1-create-terraform-storage.sh#L6-L7)
2. Run the script `./scripts/1-create-terraform-storage.sh`
3. The script will create
- Azure Resource Group
- Azure Storage Account
- Azure Blob storage location within Azure Storage Account
4. Successful script run will create a storage account with blob ready to state terraform state file

## Terraform init

Run the following command to initialise Terraform when in the remote-state-example directory:

```terraform
terraform init
```

## Terraform plan

Run the following command to create and show a plan of your Terraform configuration:

```terraform
terraform plan
```

The plan will be similar to the previous local state example, but the state file will be stored in the Azure Storage Account rather than local, as shown in image below:

![Terraform plan](/images/terraform-plan.png)

## Terraform apply

Run the following command to apply the Terraform configuration:

```terraform
terraform apply
```

Review the apply this time, remote state stored - but will deploy the similar resources as the local state example.

## Terraform destroy

Run the following command to destroy the Terraform configuration:

```terraform
terraform destroy
```

## Terraform destroy - remote state storage account

Run the following command to destroy the remote state storage account:

1. Edit the [variables](https://github.com/thomast1906/terraform-on-azure/tree/main/2-terraform-state/scripts/2-delete-terraform-storage.sh#L6)
2. Run the script `./scripts/2-delete-terraform-storage.sh`
