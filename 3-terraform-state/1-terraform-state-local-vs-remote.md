# Understand Terraform state

Terraform state tracks the resources it manages. Every time you run `terraform apply`, Terraform updates this state file with the current configuration of your Azure resources.

## What is state?

The state file maps your Terraform configuration to real Azure resources. Terraform uses it to:

- Know which resources it manages
- Detect configuration drift
- Plan changes efficiently
- Store resource metadata

## Local state

By default, Terraform stores state locally in `terraform.tfstate`:

```terraform
terraform {
  backend "local" {}
}
```

Local state works for:
- Learning and experimentation
- Personal projects
- Single-user scenarios

Local state doesn't work for:
- Team collaboration (no one else can access your state)
- CI/CD pipelines (each run starts fresh)
- Production environments (state can be lost or corrupted)

## Remote state

Remote state stores your state file in a shared location. For Azure, use an Azure Storage Account:

```terraform
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate12345"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

Remote state gives you:

- State locking prevents concurrent modifications, so teammates do not run `terraform apply` at the same time.
- Collaboration improves because everyone works from the same state and sees changes immediately.
- Security improves with encryption, access controls, and audit logs in Azure Storage.
- Durability improves with built-in redundancy.
- History is available when blob versioning is enabled.

## When to use each

Use local state:
- You're learning Terraform
- You're the only person working on the code
- The infrastructure is temporary (testing, demos)

Use remote state:
- Multiple people work on the infrastructure
- You run Terraform from CI/CD
- The infrastructure is production or shared
- You need audit trails

## Next steps

In the following sections, you'll:
1. Deploy infrastructure using local state
2. Set up an Azure Storage Account for remote state
3. Migrate from local to remote state
4. Deploy infrastructure using remote state
