# Section 1: Terraform Basics

Welcome to your Terraform journey! This foundational section will equip you with the essential knowledge and tools needed to start working with Terraform on Azure.

## 🎯 Learning Objectives

By the end of this section, you will be able to:
- **Install and configure** Terraform on your system
- **Understand** the core Terraform workflow and commands
- **Create** your first Terraform configuration files
- **Deploy** simple Azure resources using Terraform
- **Configure** the Azure provider for authentication
- **Follow** Terraform best practices from the beginning

## 📋 Prerequisites

- **Azure Account** with an active subscription ([Get a free account](https://azure.microsoft.com/en-us/free/))
- **Basic command-line knowledge** (Terminal/PowerShell)
- **Text editor** installed (VS Code recommended)
- **Administrative privileges** on your computer for software installation

## 🗺️ Section Structure

This section is organized into 4 progressive subsections:

### [1. Terraform Installation](./1-terraform-installation/)
- Modern installation methods for Windows, macOS, and Linux
- Version management and verification
- VS Code setup with Terraform extensions
- Environment configuration

### [2. Terraform Commands](./2-terraform-commands/)
- Essential Terraform CLI commands
- Workflow understanding (init → plan → apply → destroy)
- Debugging and troubleshooting commands
- Best practices for command usage

### [3. Terraform Resources](./3-terraform-resources/)
- Understanding Terraform resource syntax
- HCL (HashiCorp Configuration Language) fundamentals
- Resource blocks, arguments, and attributes
- Your first Azure resource deployment

### [4. Azure Provider Configuration](./4-terraform-azure-provider/)
- Azure provider setup and authentication
- Service principal vs Azure CLI authentication
- Provider versioning and constraints
- Region and subscription management

## 🚀 Getting Started

### Quick Setup Verification

Before diving into the tutorials, verify your setup:

```bash
# Check if Azure CLI is installed and authenticated
az --version
az account show

# After installing Terraform (covered in subsection 1)
terraform version

# Check if you have a text editor
code --version  # VS Code
```

### Expected Time Investment

- **Total Section Time**: 45-60 minutes
- **Hands-on Practice**: 30 minutes
- **Reading and Setup**: 15-30 minutes

## 🏗️ What You'll Build

By the completion of this section, you'll have:

1. **Terraform installed** and configured on your system
2. **Created your first** Terraform configuration
3. **Deployed an Azure Resource Group** using Terraform
4. **Understood the complete** Terraform workflow
5. **Configured authentication** for Azure deployments

### Sample Configuration Preview

Here's a preview of what you'll be creating:

```hcl
# Your first Terraform configuration
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-terraform-basics"
  location = "East US"

  tags = {
    Environment = "Learning"
    Purpose     = "Terraform Basics Tutorial"
  }
}
```

## ✅ Success Criteria

You'll know you've successfully completed this section when you can:

- [ ] Install Terraform using your preferred method
- [ ] Run `terraform version` and see version information
- [ ] Authenticate with Azure using `az login`
- [ ] Create a simple Terraform configuration file
- [ ] Successfully run `terraform init`, `terraform plan`, and `terraform apply`
- [ ] Deploy an Azure resource group using Terraform
- [ ] Clean up resources using `terraform destroy`

## 🛠️ Troubleshooting Guide

### Common Issues and Solutions

**Issue: Terraform command not found**
```bash
# Verify installation
which terraform
echo $PATH

# Reinstall or add to PATH
export PATH=$PATH:/usr/local/bin
```

**Issue: Azure authentication failed**
```bash
# Re-authenticate
az login
az account set --subscription "your-subscription-name"
```

**Issue: Permission denied errors**
```bash
# Check Azure permissions
az account show
az role assignment list --assignee $(az account show --query user.name -o tsv)
```

## 💡 Pro Tips

- **Use consistent naming** - Follow Azure naming conventions from the start
- **Enable auto-completion** - Set up shell completion for Terraform commands
- **Pin provider versions** - Always specify provider version constraints
- **Start small** - Begin with simple resources before complex configurations
- **Read error messages** - Terraform provides helpful error descriptions

## 🔗 Quick Links

- [Terraform Documentation](https://developer.hashicorp.com/terraform)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)
- [VS Code Terraform Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

## 🎓 Learning Path Navigation

**Previous**: [Main Repository](../) | **Current**: Section 1: Terraform Basics | **Next**: [Section 2: Terraform Variables](../2-terraform-variables/)

---

**Ready to begin?** Start with [Terraform Installation](./1-terraform-installation/) and work through each subsection sequentially.

*Remember: Take your time with each concept. A solid foundation in the basics will make advanced topics much easier to understand!* 🏗️