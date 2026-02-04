# Core Terraform commands

You'll use these commands constantly. They form the standard workflow for deploying infrastructure.

## Initialize your workspace

```bash
terraform init
```

This downloads provider plugins and sets up your backend. Run it once when you start a new project, or when you add new providers.

## Check your syntax

```bash
terraform validate
```

Validates your configuration files. Use this to catch syntax errors before running `plan`.

## Preview changes

```bash
terraform plan
```

Shows what Terraform will create, update, or delete. Always run this before applying changes. The output uses symbols:

- `+` creates a new resource
- `~` modifies an existing resource
- `-` deletes a resource
- `-/+` replaces a resource (deletes then recreates)

## Apply changes

```bash
terraform apply
```

Applies your configuration to Azure. Terraform shows you the plan and asks for confirmation. Type `yes` to proceed.

To skip the confirmation prompt:

```bash
terraform apply -auto-approve
```

Use auto-approve only in CI/CD pipelines or when you're certain about the changes.

## Destroy resources

```bash
terraform destroy
```

Deletes all resources Terraform manages. Use this to clean up when you're done testing.

## Format your code

```bash
terraform fmt
```

Formats all `.tf` files in your directory to match Terraform style conventions. Run this before committing code.

## Check version

```bash
terraform version
```

Shows your Terraform version. Useful when troubleshooting or confirming you're on the latest release.

## Standard workflow

Here's the typical sequence you'll follow:

1. Write your configuration in `.tf` files
2. Run `terraform init` (only needed once)
3. Run `terraform validate` to check for errors
4. Run `terraform plan` to preview changes
5. Run `terraform apply` to deploy
6. Run `terraform destroy` when you're done

Always run `validate` before `plan`, and always run `plan` before `apply`.