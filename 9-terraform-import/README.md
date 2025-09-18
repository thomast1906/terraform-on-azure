# Terraform Import - Managing Existing Azure Resources

One of the most common real-world scenarios is incorporating existing Azure infrastructure into Terraform management. This section teaches you how to import existing resources, manage brownfield environments, and migrate from other IaC tools.

## 🎯 Learning Objectives

By completing this section, you will learn how to:
- **Import** existing Azure resources into Terraform state
- **Generate** Terraform configuration from existing infrastructure
- **Migrate** from Azure Resource Manager templates to Terraform
- **Handle** complex resource dependencies during import
- **Validate** imported resources and state consistency

## 📋 Prerequisites

- Completed sections 1-8 of this learning path
- Existing Azure resources to practice with (or create sample resources)
- Understanding of Terraform state management
- Azure CLI configured and authenticated

## 🔄 Understanding Terraform Import

### When to Use Import

**Common Scenarios:**
- **Existing Infrastructure** - Resources created outside Terraform
- **Team Migration** - Moving from ARM templates or manual processes
- **Partial Adoption** - Gradually adopting Terraform for existing workloads
- **Disaster Recovery** - Recreating lost Terraform state
- **Resource Conflicts** - Resolving "already exists" errors

### Import Process Overview

```bash
# 1. Write Terraform configuration for the resource
# 2. Import the resource into state
terraform import <resource_type>.<resource_name> <resource_id>

# 3. Verify and adjust configuration
terraform plan

# 4. Test with plan/apply cycle
terraform apply
```

## 1. Basic Resource Import

### Example: Importing a Resource Group

**Step 1: Create existing resource (if needed)**
```bash
# Create a resource group outside Terraform
az group create --name "existing-rg" --location "East US"
```

**Step 2: Write Terraform configuration**
```hcl
# main.tf
terraform {
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

# Configuration for the existing resource group
resource "azurerm_resource_group" "imported" {
  name     = "existing-rg"
  location = "East US"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

**Step 3: Import the resource**
```bash
# Initialize Terraform
terraform init

# Import the resource group
terraform import azurerm_resource_group.imported /subscriptions/{subscription-id}/resourceGroups/existing-rg

# Verify the import
terraform show
```

**Step 4: Validate configuration**
```bash
# Check for differences
terraform plan

# If plan shows changes, adjust configuration to match actual resource
terraform apply
```

## 📚 Additional Resources

- [Terraform Import Documentation](https://developer.hashicorp.com/terraform/cli/import)
- [Azure Resource ID Formats](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)
- [Terraformer Tool](https://github.com/GoogleCloudPlatform/terraformer)
- [AzAPI Provider for Latest Azure Features](https://registry.terraform.io/providers/Azure/azapi/latest)

## 🎯 Key Takeaways

- **Import is not migration** - You still need to write proper Terraform configuration
- **Order matters** - Import dependent resources in the correct sequence  
- **Validate everything** - Always run `terraform plan` after import
- **Backup state** - Protect your existing Terraform state before import operations
- **Practice first** - Test import procedures in development environments

**Next Step:** Ready to set up CI/CD for your Terraform? Continue to [Section 10: Terraform CI/CD with GitHub Actions](../10-terraform-cicd/)

---

*Import is your bridge between existing infrastructure and Infrastructure as Code.* 🌉