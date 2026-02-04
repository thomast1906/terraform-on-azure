# Terraform basics

Get Terraform running on your machine and deploy your first Azure resource in minutes.

## What you'll learn

This section covers everything you need to start using Terraform with Azure:

- Installing Terraform on your system
- Setting up VS Code for Terraform development
- Understanding core Terraform commands
- Working with resources and data sources
- Configuring the Azure provider for authentication

By the end of this section, you'll deploy a real Azure resource group using Terraform.

## Tutorials

Work through these in order:

### [1. Install Terraform](./1-terraform-installation/1-terraform-install.md)

Download and install Terraform on macOS, Windows, or Linux. Verify your installation and understand version management.

**What you'll do:**
- Install Terraform using package managers (Homebrew, Chocolatey, or direct download)
- Verify installation with `terraform version`
- Understand Terraform's release cycle

### [2. Set up VS Code](./1-terraform-installation/2-vscode-install.md)

Configure VS Code with the HashiCorp Terraform extension for syntax highlighting, autocompletion, and validation.

**What you'll do:**
- Install VS Code (if needed)
- Add the HashiCorp Terraform extension
- Configure extension settings
- Learn keyboard shortcuts

### [3. Core commands](./2-terraform-commands/1-terraform-commands.md)

Learn the essential Terraform workflow commands you'll use every day.

**What you'll do:**
- Initialize projects with `terraform init`
- Preview changes with `terraform plan`
- Apply infrastructure with `terraform apply`
- Destroy resources with `terraform destroy`
- Understand what each command does

### [4. Resources and data sources](./3-terraform-resources/1-terraform-resources.md)

Understand the building blocks of Terraform configurations: resources (what you create) and data sources (what you look up).

**What you'll do:**
- Write your first resource block
- Query existing Azure resources with data sources
- Reference data between resources
- Deploy a complete example

### [5. Configure Azure provider](./4-terraform-azure-provider/1-azure-provider.md)

Set up authentication to Azure and configure the AzureRM provider.

**What you'll do:**
- Authenticate with `az login`
- Configure the Azure provider in Terraform
- Understand provider versions
- Deploy your first Azure resource group

## Prerequisites

Before starting this section, make sure you have:

- An Azure account ([free tier](https://azure.microsoft.com/en-us/free/) works fine)
- Command line access (Terminal on macOS/Linux, PowerShell on Windows)
- Administrator/sudo access to install software

No prior Terraform or Azure experience required.

## Quick start

Want to see Terraform in action right away?

```bash
# 1. Install Terraform (macOS example)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# 2. Sign in to Azure
az login

# 3. Create a working directory
mkdir terraform-test
cd terraform-test

# 4. Create a simple Terraform file
cat > main.tf << 'EOF'
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-test"
  location = "uksouth"
}
EOF

# 5. Deploy
terraform init
terraform apply

# 6. Clean up
terraform destroy
```

Congratulations! You just deployed and destroyed Azure infrastructure with Terraform.

## Next steps

After completing this section:

1. Practice by modifying the examples. Try different resource names and locations.
2. Experiment by adding tags to resources and using different Azure regions.
3. Continue to [section 2: Variables](../2-terraform-variables/) to make your code reusable.

## Getting help

Stuck on something?

- Check the [Terraform documentation](https://www.terraform.io/docs)
- Review the [Azure provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- Open an [issue on this repository](https://github.com/thomast1906/terraform-on-azure/issues)

## Structure

This section contains:

```
1-terraform-basics/
├── README.md (you are here)
├── 1-terraform-installation/
│   ├── README.md
│   ├── 1-terraform-install.md
│   └── 2-vscode-install.md
├── 2-terraform-commands/
│   ├── README.md
│   └── 1-terraform-commands.md
├── 3-terraform-resources/
│   ├── README.md
│   └── 1-terraform-resources.md
└── 4-terraform-azure-provider/
    ├── README.md
    └── 1-azure-provider.md
```

Start with [1. Install Terraform](./1-terraform-installation/1-terraform-install.md) →
